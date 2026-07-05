// ai.controller.ts (নতুন কন্ট্রোলার)
import { Request, Response } from "express";
import { generateGeminiCaption } from "../../utils/gemini";

// export const aiController = {
//   generateCaption: async (req: Request, res: Response) => {
//     try {
//       const files = req.files as Express.Multer.File[];
//       if (!files || files.length === 0) {
//         return res.status(400).json({ valid: false, message: "No images provided" });
//       }

//       const buffers = files.map(file => file.buffer); // Multer memory storage হতে হবে
//       const aiResult = await generateGeminiCaption(buffers);

//       res.status(200).json({
//         valid: true,
//         title: aiResult.title,
//         description: aiResult.description
//       });
//     } catch (error) {
//       res.status(500).json({ valid: false, message: "AI generation failed" });
//     }
//   }
// };

export const aiController = {
  generateCaption: async (req: Request, res: Response) => {
    try {
      console.log("📡 [AI] নতুন রিকোয়েস্ট এসেছে!");
      const files = req.files as Express.Multer.File[];
      
      if (!files || files.length === 0) {
        console.log("❌ [AI] কোনো ইমেজ পাওয়া যায়নি");
        return res.status(400).json({ valid: false, message: "No images provided" });
      }

      console.log(`📸 [AI] ${files.length}টি ইমেজ প্রসেস করা হচ্ছে...`);
      const buffers = files.map(file => file.buffer);
      
      const aiResult = await generateGeminiCaption(buffers);
      console.log("✅ [AI] জেমিনি ক্যাপশন জেনারেট করেছে:", aiResult.title);

      res.status(200).json({
        valid: true,
        title: aiResult.title,
        description: aiResult.description
      });
    } catch (error: any) {
      console.error("💥 [AI] কন্ট্রোলার এরর:", error.message);
      res.status(500).json({ valid: false, message: "AI generation failed" });
    }
  }
};

// রুট ফাইলে:
// router.post('/generate-caption', multerUpload.array('images', 5), aiController.generateCaption);