/* eslint-disable @typescript-eslint/no-explicit-any */
import sgMail from "@sendgrid/mail";
import path from "path";
import ejs from "ejs";
import { envVar } from "../config/envVar";
import AppError from "../errorHelper/AppError";

sgMail.setApiKey(envVar.EMAIL.SENDGRID_API_KEY);

interface SendEmailOptions {
  to: string;
  subject: string;
  templateName: string;
  templateData?: Record<string, any>;
}

export const sendEmail = async ({
  to,
  subject,
  templateName,
  templateData,
}: SendEmailOptions) => {
  try {
    const templatePath = path.join(__dirname, "../utils/templates", `${templateName}.ejs`);
    let html: string;
    
    try {
      html = await ejs.renderFile(templatePath, templateData);
    } catch (err) {
      console.warn(`⚠️ EJS template file not found at ${templatePath}, using default HTML template.`);
      html = `<div style="font-family: Arial, sans-serif; padding: 20px;">
        <h2>${subject}</h2>
        <p>Hello ${templateData?.name || "User"},</p>
        <p>Your OTP verification code is: <b style="font-size: 24px; color: #4CAF50;">${templateData?.otp || ""}</b></p>
        <p>This code will expire in 2 minutes.</p>
      </div>`;
    }

    // In development mode, or if SendGrid API Key is dummy/empty, bypass real sending
    if (
      envVar.NODE_ENV === "development" ||
      !envVar.EMAIL.SENDGRID_API_KEY ||
      envVar.EMAIL.SENDGRID_API_KEY.includes("your_sendgrid_api_key")
    ) {
      console.log("\n==================================================");
      console.log("📧 [DEV MODE] EMAIL SIMULATION");
      console.log(`To: ${to}`);
      console.log(`Subject: ${subject}`);
      console.log(`OTP Code: ${templateData?.otp}`);
      console.log("==================================================\n");
      return true;
    }

    const msg = {
      to,
      from: {
        email: envVar.EMAIL.SENDGRID_FROM_EMAIL || "no-reply@epic.nz",
        name: envVar.EMAIL.SENDGRID_FROM_NAME || "Epic NZ",
      },
      subject,
      html,
    };

    try {
      await sgMail.send(msg);
    } catch (sendgridErr: any) {
      console.error("⚠️ SendGrid email dispatch failed (proceeding without breaking process):", sendgridErr?.response?.body || sendgridErr?.message || sendgridErr);
    }

    return true;
  } catch (error: any) {
    console.error("Error sending email:", error.message);
    return false;
  }
};
