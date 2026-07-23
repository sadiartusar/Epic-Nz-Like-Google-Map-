import { GoogleGenerativeAI } from "@google/generative-ai";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY as string);

// export const generateGeminiCaption = async (imageBuffers: Buffer[]) => {
//   const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

  
//   const imageParts = imageBuffers.map((buffer) => ({
//     inlineData: {
//       data: buffer.toString("base64"),
//       mimeType: "image/jpeg",
//     },
//   }));

//   const prompt = `Analyze these images of a location in New Zealand. 
//     Provide a catchy 'title' and a detailed 'description' for a travel app. 
//     Return the result strictly in JSON format like this: 
//     {"title": "Spot Name", "description": "Beautiful description..."}`;

//   const result = await model.generateContent([prompt, ...imageParts]);
//   const response = await result.response;
//   const text = response.text();

//   const jsonMatch = text.match(/\{.*\}/s);
//   if (jsonMatch) {
//     return JSON.parse(jsonMatch[0]);
//   }
  
//   throw new Error("Failed to parse AI response");
// };

export const generateGeminiCaption = async (imageBuffers: Buffer[]) => {
  console.log("🤖 জেমিনিকে প্রম্পট পাঠানো হচ্ছে...");
  const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

  const imageParts = imageBuffers.map((buffer) => ({
    inlineData: { data: buffer.toString("base64"), mimeType: "image/jpeg" },
  }));

  const prompt = `Analyze these images of a location in New Zealand. Provide a catchy 'title' and a detailed 'description' for a travel app. Return the result strictly in JSON format: {"title": "...", "description": "..."}`;

  const result = await model.generateContent([prompt, ...imageParts]);
  const response = await result.response;
  const text = response.text();

  console.log("📥 জেমিনি থেকে প্রাপ্ত টেক্সট:", text);
  
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (jsonMatch) {
    try {
      return JSON.parse(jsonMatch[0]);
    } catch (e: any) {
      console.error("💥 JSON parsing failed for matched block:", e.message);
    }
  }

  // Fallback to original clean logic if match fails
  const cleanJson = text.replace(/```json/g, "").replace(/```/g, "").trim();
  return JSON.parse(cleanJson);
};