import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [sveltekit()],
  server: {
    port: 3000
  },
  preview: {
    port: 3000,
    allowedHosts: ['sn-sn.my.id']  // 👈 your custom domain
  }
});