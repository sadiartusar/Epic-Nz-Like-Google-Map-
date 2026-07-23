/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unused-vars */
import { NextFunction, Request, Response } from "express";
import mongoose from "mongoose";
import AppError from "./AppError";
import { JsonWebTokenError, TokenExpiredError } from "jsonwebtoken";

const globalErrorHandler = (
  err: any,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  // Custom AppError
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      status: "error",
      message: err.message,
    });
  }

  if (
    err instanceof SyntaxError &&
    "status" in err &&
    (err as any).status === 400 &&
    "body" in err
  ) {
    return res.status(400).send({
      success: false,
      message: "Bad JSON formatting or incorrect Content-Type header",
    });
  }
  // Mongoose invalid ObjectId
  if (err instanceof mongoose.Error.CastError) {
    return res.status(400).json({
      status: "error",
      message: `Invalid ${err.path}: ${err.value}`,
    });
  }

  // Mongoose Duplicate Key Error (E11000)
  if (err.code === 11000) {
    const keys = Object.keys(err.keyValue || {});
    const field = keys.length > 0 ? keys[0] : "field";
    return res.status(400).json({
      status: "error",
      message: `User with this ${field} already exists. Please login!`,
    });
  }

  // Mongoose Validation Error
  if (err instanceof mongoose.Error.ValidationError) {
    return res.status(400).json({
      status: "error",
      message: err.message,
    });
  }

  // JWT errors
  if (err instanceof JsonWebTokenError) {
    return res.status(401).json({
      status: "error",
      message: "Invalid token. Please login again.",
    });
  }

  if (err instanceof TokenExpiredError) {
    return res.status(401).json({
      status: "error",
      message: "Token has expired. Please login again.",
    });
  }

  console.error("💥 Server Error:", err);

  const statusCode = err.statusCode || err.status || 500;
  return res.status(statusCode).json({
    status: "error",
    message: err.message || "Something went wrong! Please try again later.",
    ...(process.env.NODE_ENV !== "production" && { stack: err.stack }),
  });
};

export default globalErrorHandler;
