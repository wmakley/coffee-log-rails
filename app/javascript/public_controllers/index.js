import { application } from "../controllers/application"

import RecaptchaV3Controller from "./recaptcha_v3_controller";
application.register("recaptcha-v3", RecaptchaV3Controller)
