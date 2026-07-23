import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

interface CLOUDINARY_TYPE {
  CLOUDINARY_NAME: string;
  CLOUDINARY_API_KEY: string;
  CLOUDINARY_SECRET: string;
}

interface REDIS_TYPE {
  REDIS_HOST: string;
  REDIS_PORT: string;
  REDIS_USERNAME: string;
  REDIS_PASSWORD: string;
}

interface EMAIL_TYPE  {
  SENDGRID_API_KEY: string;
  SENDGRID_FROM_EMAIL: string;
  SENDGRID_FROM_NAME: string;
}

interface GOOGLE_TYPE {
  GOOGLE_CLIENT_ID: string;
  GOOGLE_CLIENT_SECRET: string;
  GOOGLE_CALLBACK_URL: string;
}

interface APPLE_AUTH_TYPE {
  APPLE_CLIENT_ID: string;
  APPLE_TEAM_ID: string;
  APPLE_KEY_ID: string;
  APPLE_PRIVATE_KEY_PATH: string;
  APPLE_CALLBACK_URL: string;
}

interface EnvVar {
  PORT: string;
  NODE_ENV: "development" | "production";
  MONGO_URI: string;
  JWT_SECRET: string;
  JWT_EXPIRATION: string;
  JWT_REFRESH_SECRET: string;
  JWT_REFRESH_EXPIRATION: string;
  BCRYPT_SALT_ROUND: string;
  EXPRESS_SESSION_SECRET: string;
  FRONTEND_URL: string;
  APP_URL: string;
  CLOUDINARY: CLOUDINARY_TYPE;
  REQUEST_RATE_LIMIT: string;
  REQUEST_RATE_LIMIT_TIME: string;
  STRIPE_SECRET_KEY: string;
  STRIPE_PUBLISHABLE_KEY: string;
  STRIPE_WEBHOOK_SECRET: string;
  PRICE_YEARLY: string;
  PRICE_MONTHLY: string;
  REDIS: REDIS_TYPE;
  EMAIL: EMAIL_TYPE ;
  GOOGLE_AUTH: GOOGLE_TYPE;
  APPLE_AUTH: APPLE_AUTH_TYPE;
  SESSION_SECRET: string;
  OPENWEATHER_API_KEY: string;
  WEATHER_API_URL: string;
  MAP_BOX_ACCESS_TOKEN: string;
  FIREBASE_SERVICE_ACCOUNT_PATH: string;
  SUPER_ADMIN_EMAIL: string;
  SUPER_ADMIN_PASSWORD: string;
}

const loadEnvVariables = (): EnvVar => {
  return {
    PORT: process.env.PORT || "5000",
    NODE_ENV: (process.env.NODE_ENV as "development" | "production") || "production",
    MONGO_URI: process.env.MONGO_URI || "",
    JWT_SECRET: process.env.JWT_SECRET || "my_super_secret_jwt_key",
    JWT_EXPIRATION: process.env.JWT_EXPIRATION || "7d",
    JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET || "my_super_secret_refresh_key",
    JWT_REFRESH_EXPIRATION: process.env.JWT_REFRESH_EXPIRATION || "30d",
    BCRYPT_SALT_ROUND: process.env.BCRYPT_SALT_ROUND || "10",
    EXPRESS_SESSION_SECRET: process.env.EXPRESS_SESSION_SECRET || "my_session_secret",
    FRONTEND_URL: process.env.FRONTEND_URL || "*",
    APP_URL: process.env.APP_URL || "http://localhost:5000",
    CLOUDINARY: {
      CLOUDINARY_NAME: process.env.CLOUDINARY_NAME || "",
      CLOUDINARY_API_KEY: process.env.CLOUDINARY_API_KEY || "",
      CLOUDINARY_SECRET: process.env.CLOUDINARY_SECRET || "",
    },
    REQUEST_RATE_LIMIT: process.env.REQUEST_RATE_LIMIT || "100",
    REQUEST_RATE_LIMIT_TIME: process.env.REQUEST_RATE_LIMIT_TIME || "15",
    STRIPE_SECRET_KEY: process.env.STRIPE_SECRET_KEY || "",
    STRIPE_PUBLISHABLE_KEY: process.env.STRIPE_PUBLISHABLE_KEY || "",
    STRIPE_WEBHOOK_SECRET: process.env.STRIPE_WEBHOOK_SECRET || "",
    PRICE_YEARLY: process.env.PRICE_YEARLY || "100",
    PRICE_MONTHLY: process.env.PRICE_MONTHLY || "10",
    REDIS: {
      REDIS_HOST: process.env.REDIS_HOST || "127.0.0.1",
      REDIS_PORT: process.env.REDIS_PORT || "6379",
      REDIS_USERNAME: process.env.REDIS_USERNAME || "default",
      REDIS_PASSWORD: process.env.REDIS_PASSWORD || "",
    },
    EMAIL: {
      SENDGRID_API_KEY: process.env.SENDGRID_API_KEY || "",
      SENDGRID_FROM_EMAIL: process.env.SENDGRID_FROM_EMAIL || "dev@epic.nz",
      SENDGRID_FROM_NAME: process.env.SENDGRID_FROM_NAME || "Epic NZ",
    },
    GOOGLE_AUTH: {
      GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID || "",
      GOOGLE_CLIENT_SECRET: process.env.GOOGLE_CLIENT_SECRET || "",
      GOOGLE_CALLBACK_URL: process.env.GOOGLE_CALLBACK_URL || "",
    },
    APPLE_AUTH: {
      APPLE_CLIENT_ID: process.env.APPLE_CLIENT_ID || "",
      APPLE_TEAM_ID: process.env.APPLE_TEAM_ID || "",
      APPLE_KEY_ID: process.env.APPLE_KEY_ID || "",
      APPLE_PRIVATE_KEY_PATH: process.env.APPLE_PRIVATE_KEY_PATH || "",
      APPLE_CALLBACK_URL: process.env.APPLE_CALLBACK_URL || "",
    },
    SESSION_SECRET: process.env.SESSION_SECRET || "my_session_secret",
    OPENWEATHER_API_KEY: process.env.OPENWEATHER_API_KEY || "",
    WEATHER_API_URL: process.env.WEATHER_API_URL || "https://api.openweathermap.org/data/2.5/weather",

    MAP_BOX_ACCESS_TOKEN: process.env.MAP_BOX_ACCESS_TOKEN || "",
    FIREBASE_SERVICE_ACCOUNT_PATH: process.env.FIREBASE_SERVICE_ACCOUNT_PATH || "./firebase-admin.json",
    SUPER_ADMIN_EMAIL: process.env.SUPER_ADMIN_EMAIL || "admin@example.com",
    SUPER_ADMIN_PASSWORD: process.env.SUPER_ADMIN_PASSWORD || "admin123",
  };
};

export const envVar = loadEnvVariables();
