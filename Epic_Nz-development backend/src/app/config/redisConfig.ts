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
