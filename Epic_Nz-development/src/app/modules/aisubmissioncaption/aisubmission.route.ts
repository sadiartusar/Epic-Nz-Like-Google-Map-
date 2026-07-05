import { Router } from "express";
import { aiController } from "./aisubmission.controller";
import { memoryUpload } from "../../config/multer.config";


const router = Router();

router.post('/generate-caption', memoryUpload.array('images', 5), aiController.generateCaption);

export const aiSubmissionRoute = router;
