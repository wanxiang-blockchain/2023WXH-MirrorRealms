import { fileURLToPath, URL } from 'node:url';

import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import AutoImport from 'unplugin-auto-import/vite';
import Components from 'unplugin-vue-components/vite';
import { NaiveUiResolver } from 'unplugin-vue-components/resolvers';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    // AutoImport({
    //   imports: [
    //     'vue',
    //     {
    //       'naive-ui': [
    //         'useDialog',
    //         'useMessage',
    //         'useNotification',
    //         'useLoadingBar',
    //         'useButton',
    //         'useInput',
    //       ],
    //     },
    //   ],
    // }),
    // Components({
    //   resolvers: [NaiveUiResolver()],
    // }),
  ],
  server: {
    host: '0.0.0.0',
    proxy: {
      '/mrbev1': {
        target: 'https://mirror-realms.io', //跨域地址
        changeOrigin: true, //支持跨域
        rewrite: (path) => path.replace(/^\/mrbev1/, '/mrbev1'), //重写路径,替换/api
      },
    },
  },
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: '@import "@/assets/styles/var.scss";',
      },
    },
  },
});
