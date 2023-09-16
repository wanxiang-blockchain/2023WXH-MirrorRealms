<template>
  <TheModal :visible="visible" :width="651" @close="close">
    <div class="login-modal-wrapper">
      <!-- 绑定邮箱 -->
      <div class="bind-email" v-if="step === 'robot_check' || step === 'bind_email'">
        <div class="title">Bind Email</div>

        <!-- 邮箱 -->
        <div class="verify-wrapper" v-if="step === 'robot_check'">
          <slide-verify
            ref="verifyRef"
            @again="onAgain"
            @success="onSuccess"
            @fail="onFail"
          ></slide-verify>
        </div>

        <n-button
          v-if="step === 'robot_check'"
          :disabled="rebotCheckResult === false"
          class="btn robot-btn"
          color="#000"
          @click="step = 'bind_email'"
          >Please prove you are not a robot</n-button
        >

        <!-- 验证码 -->
        <TheInput
          v-if="step === 'bind_email'"
          class-name="email-input"
          label="Email"
          v-model="loginForm.email"
        />
        <div v-if="step === 'bind_email'" class="form-code">
          <TheInput
            label="verification code"
            class-name="code-input"
            :no-margin="true"
            v-model="loginForm.code"
          />
          <n-button
            class="btn code-btn"
            color="#000"
            :disabled="!loginForm.email || codeCount > 0"
            :loading="codeLoading"
            @click="getCode"
            >{{ codeCount <= 0 ? 'Send Code' : `${codeCount}s` }}</n-button
          >
        </div>

        <div class="tips">
          <div class="error-msg" v-if="errorMsg">{{ errorMsg }}</div>
          <div>Binding email can get the lastest news of NFTs and game in time.</div>
          <div>Email can alse be used for game login.</div>
        </div>

        <n-button
          v-if="step === 'bind_email'"
          class="btn next-btn"
          color="#000"
          :disabled="!loginForm.email || !loginForm.code"
          :loading="loading"
          @click="bindEmail"
          >Next</n-button
        >
      </div>

      <!-- 设置密码 -->
      <div class="set-password" v-if="step === 'password'">
        <div class="title">Set Passwod</div>

        <TheInput
          label="passwrod"
          type="password"
          show-password-on="click"
          v-model="loginForm.password"
        />
        <TheInput
          label="check passwrod"
          type="password"
          show-password-on="click"
          v-model="loginForm.checkPassword"
        />

        <div class="tips">
          <div class="error-msg" v-if="errorMsg">{{ errorMsg }}</div>
          <div>Must contain 0-9, a-Z</div>
          <div>This password is used for game login with your email account.</div>
        </div>

        <n-button class="btn" color="#000" :loading="loading" @click="changePassWord"
          >Submit</n-button
        >
      </div>
    </div>
  </TheModal>
</template>

<script lang="ts" setup>
import 'vue3-slide-verify/dist/style.css';
import { ref } from 'vue';
import { NButton } from 'naive-ui';
import SlideVerify from 'vue3-slide-verify';
import md5 from 'md5';

import TheModal from './TheModal.vue';
import TheInput from './TheInput.vue';

import * as api from '@/api/petra';
import { checkEmail, checkPassword } from '@/utils/regExp';

interface ILoginForm {
  email: string;
  code: string;
  password: string;
  checkPassword: string;
}
type IStep = 'robot_check' | 'bind_email' | 'password';

const defaultLoginForm = { email: '', code: '', password: '', checkPassword: '' };

const visible = ref(false);
const codeCount = ref(0); // 验证吗倒计时
let codeTimer: any = null; // 验证吗timer

function open() {
  visible.value = true;
}

function close() {
  visible.value = false;
  clearInterval(codeTimer);
  codeCount.value = 0;
  loginForm.value = { ...defaultLoginForm };
  errorMsg.value = '';
}

defineExpose({
  open,
  close,
});

const emit = defineEmits(['bind']);

const step = ref<IStep>('robot_check');
const loginForm = ref<ILoginForm>({ ...defaultLoginForm });
const codeLoading = ref(false);
const loading = ref(false);
const errorMsg = ref('');
const rebotCheckResult = ref(false);

// 图形验证插件相关
const verifyRef = ref();
const msg = ref('');

const onAgain = () => {
  msg.value = 'Validation failed！ try again';
  // 刷新
  verifyRef.value?.refresh();
};

const onSuccess = () => {
  msg.value = 'success';
  rebotCheckResult.value = true;
};

const onFail = () => {
  msg.value = 'failed';
};

/**
 * 获取邮箱验证码
 */
async function getCode() {
  if (!checkEmail(loginForm.value.email)) {
    errorMsg.value = 'Please enter the correct email address';
    return;
  } else {
    errorMsg.value = '';
  }
  try {
    codeLoading.value = true;
    await api.sendEmailBindCode({ email: loginForm.value.email });
    codeCount.value = 60;
    codeTimer = setInterval(() => {
      if (codeCount.value > 0) {
        codeCount.value -= 1;
      } else {
        clearInterval(codeTimer);
      }
    }, 1000);
  } finally {
    codeLoading.value = false;
  }
}

/**
 * 绑定邮箱
 */
async function bindEmail() {
  if (!checkEmail(loginForm.value.email)) {
    errorMsg.value = 'Please enter the correct email address';
    return;
  }
  try {
    loading.value = true;
    const res = await api.webBindEmail({
      email: loginForm.value.email,
      code: loginForm.value.code,
    });
    step.value = 'password';
    if (res?.token) {
      localStorage.setItem('Authorization', `Bearer ${res?.token}`);
    }
  } finally {
    loading.value = false;
  }
}

/**
 * 设置邮箱
 */
async function changePassWord() {
  if (!checkPassword(loginForm.value.password) || !checkPassword(loginForm.value.checkPassword)) {
    errorMsg.value = 'Passwords only support entering 0-9 a-Z';
    return;
  }
  if (loginForm.value.password !== loginForm.value.checkPassword) {
    errorMsg.value = 'The two passwords do not match';
    return;
  }

  try {
    loading.value = true;
    await api.changePassword({
      old_password: '',
      new_password: md5(loginForm.value.checkPassword),
    });
    emit('bind');
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped lang="scss">
.login-modal-wrapper {
  color: #313131;

  .title {
    font-size: 32px;
    font-weight: bold;
    line-height: 40px;
    height: 74px;
    margin-bottom: 17px;
  }

  .tips {
    margin-top: 30px;
    margin-bottom: 36px;
    font-size: 14px;
    font-weight: 250;
    line-height: 17px;

    div {
      height: 29px;
    }

    .error-msg {
      color: #fc0404;
    }
  }

  :deep(.btn) {
    width: 100%;
    height: 63px;
    font-size: 24px;
    border-radius: 8px;
    font-weight: bold;
    line-height: 26px;

    &.robot-btn {
      margin-bottom: 33px;
    }
  }

  .form-code {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .code-input {
      input {
        height: 20px;
        line-height: 20px;
      }
    }

    .code-btn {
      width: 180px;
      height: 54px;
      line-height: 54px;
      margin-left: 7px;
    }
  }

  .verify-wrapper {
    display: flex;
    justify-content: center;
    padding: 20px;
    margin-bottom: 15px;
    // background: #f2f2f2;
  }
}
</style>
