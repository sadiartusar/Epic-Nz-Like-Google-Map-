/* eslint-disable @typescript-eslint/no-explicit-any */
import { createClient } from "redis";
import { envVar } from "./envVar";

export const redisClient = createClient({
  socket: {
    host: envVar.REDIS.REDIS_HOST || "127.0.0.1",
    port: Number(envVar.REDIS.REDIS_PORT) || 6379,
    reconnectStrategy: (retries) => {
      // Stop retrying if Redis is not available or after 3 attempts
      if (retries > 3 || (envVar.NODE_ENV === "production" && (envVar.REDIS.REDIS_HOST === "127.0.0.1" || !envVar.REDIS.REDIS_HOST))) {
        return new Error("Redis connection disabled or unreachable");
      }
      return Math.min(retries * 100, 3000);
    },
  },
});

redisClient.on("error", (error: any) => {
  if (redisClient.isOpen) {
    console.log("Redis client error", error?.message || error);
  }
});

export const connectRedis = async () => {
  // Skip Redis connection in production if host is default localhost
  if (envVar.NODE_ENV === "production" && (envVar.REDIS.REDIS_HOST === "127.0.0.1" || !envVar.REDIS.REDIS_HOST)) {
    console.log("ℹ️ Skipping local Redis connection on production environment");
    return;
  }

  try {
    if (!redisClient.isOpen) {
      await redisClient.connect();
      console.log("✅ Redis connected");
    }
  } catch (error: any) {
    console.warn("⚠️ Redis connection failed (running without Redis):", error?.message || error);
  }
};

// In-Memory Fallback Cache when Redis is unavailable
const memoryStore = new Map<string, { value: string; expiresAt: number }>();

export const safeRedisSet = async (key: string, value: string, expireSeconds: number) => {
  if (redisClient.isOpen) {
    try {
      await redisClient.set(key, value, { EX: expireSeconds });
      return;
    } catch (e) {
      console.warn("Redis set failed, falling back to memory:", e);
    }
  }
  memoryStore.set(key, { value, expiresAt: Date.now() + expireSeconds * 1000 });
};

export const safeRedisGet = async (key: string): Promise<string | null> => {
  if (redisClient.isOpen) {
    try {
      return await redisClient.get(key);
    } catch (e) {
      console.warn("Redis get failed, falling back to memory:", e);
    }
  }
  const item = memoryStore.get(key);
  if (!item) return null;
  if (Date.now() > item.expiresAt) {
    memoryStore.delete(key);
    return null;
  }
  return item.value;
};

export const safeRedisDel = async (key: string) => {
  if (redisClient.isOpen) {
    try {
      await redisClient.del(key);
      return;
    } catch (e) {
      console.warn("Redis del failed:", e);
    }
  }
  memoryStore.delete(key);
};
