<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "form">
        <main class="erp-login-page">
            <#if message?has_content>
                <#assign rawMessage = message.summary?replace("<[^>]*>", "", "r")?trim>
                <#assign normalizedMessage = rawMessage?lower_case>
                <#assign toastMessage = rawMessage>
                <#assign toastType = message.type!'error'>
                <#if normalizedMessage?contains("invalid username or password")>
                    <#assign toastMessage = "사번 또는 비밀번호가 올바르지 않습니다.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("account is disabled")>
                    <#assign toastMessage = "비활성 계정입니다. 관리자에게 문의해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("account is temporarily disabled")>
                    <#assign toastMessage = "계정이 일시적으로 잠겼습니다. 잠시 후 다시 시도하거나 관리자에게 문의해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("login timeout") || normalizedMessage?contains("action expired")>
                    <#assign toastMessage = "로그인 시간이 만료되었습니다. 다시 로그인해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("email") && normalizedMessage?contains("sent")>
                    <#assign toastMessage = "입력한 이메일로 비밀번호 재설정 링크를 보냈습니다.">
                    <#assign toastType = "success">
                <#elseif normalizedMessage?contains("비밀번호 재설정 링크") || normalizedMessage?contains("안내 메일")>
                    <#assign toastMessage = "입력한 이메일로 비밀번호 재설정 링크를 보냈습니다.">
                    <#assign toastType = "success">
                <#elseif normalizedMessage?contains("please specify username") || normalizedMessage?contains("please specify username or email")>
                    <#assign toastMessage = "사번 또는 이메일을 입력해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("please specify password")>
                    <#assign toastMessage = "비밀번호를 입력해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("invalid email")>
                    <#assign toastMessage = "이메일 형식이 올바르지 않습니다.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?matches(".*[a-zA-Z].*")>
                    <#assign toastMessage = "로그인 처리 중 문제가 발생했습니다. 다시 시도해 주세요.">
                    <#assign toastType = "error">
                </#if>
                <#if toastType != "success" && toastType != "info">
                    <#assign toastType = "error">
                </#if>
                <div class="erp-toast erp-toast-${toastType}" role="alert" aria-live="assertive">
                    <span class="erp-toast-icon" aria-hidden="true"><#if toastType == "success">i<#else>!</#if></span>
                    <span>${toastMessage}</span>
                </div>
            </#if>

            <section class="erp-brand" aria-label="ERP login">
                <div class="erp-logo-box" aria-hidden="true">
                    <svg class="erp-logo-cube" viewBox="0 0 24 24" focusable="false">
                        <path d="M12 3.25 4.5 7.45v9.1l7.5 4.2 7.5-4.2v-9.1L12 3.25Z" />
                        <path d="M4.85 7.7 12 11.8l7.15-4.1" />
                        <path d="M12 11.8v8.45" />
                    </svg>
                </div>
                <h1>통합 부품 ERP</h1>
                <p>현대 파츠 (주)</p>
            </section>

            <form id="kc-form-login" class="erp-login-card" action="${url.loginAction}" method="post">
                <div class="erp-field">
                    <label for="username">사번 또는 이메일</label>
                    <div class="erp-input-wrap">
                        <svg class="erp-input-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <path d="M20 21a8 8 0 0 0-16 0" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                        <input
                            id="username"
                            name="username"
                            type="text"
                            value="${(login.username!'')}"
                            placeholder="HMC0001 또는 name@hyundaiparts.com"
                            autocomplete="username"
                            autofocus
                        />
                    </div>
                </div>

                <div class="erp-field">
                    <label for="password">비밀번호</label>
                    <div class="erp-input-wrap">
                        <svg class="erp-input-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <rect x="5" y="10" width="14" height="11" rx="2" />
                            <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                        </svg>
                        <input
                            id="password"
                            name="password"
                            type="password"
                            placeholder="••••••••"
                            autocomplete="current-password"
                        />
                        <button
                            class="erp-password-toggle"
                            type="button"
                            data-password-toggle="password"
                            data-show-label="비밀번호 보기"
                            data-hide-label="비밀번호 숨기기"
                            aria-label="비밀번호 보기"
                            aria-pressed="false"
                            title="비밀번호 보기"
                        >
                            <svg class="erp-eye-icon erp-eye-open" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" />
                                <circle cx="12" cy="12" r="3" />
                            </svg>
                            <svg class="erp-eye-icon erp-eye-closed" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                                <path d="m3 3 18 18" />
                                <path d="M10.6 10.7a2 2 0 0 0 2.7 2.7" />
                                <path d="M9.8 5.4A9.7 9.7 0 0 1 12 5c6 0 9.5 7 9.5 7a15.5 15.5 0 0 1-3 4.1" />
                                <path d="M6.6 6.8C4 8.5 2.5 12 2.5 12s3.5 7 9.5 7c1.5 0 2.8-.4 4-1" />
                            </svg>
                        </button>
                    </div>
                </div>

                <button class="erp-login-button" name="login" id="kc-login" type="submit">로그인</button>
                <#if realm.resetPasswordAllowed>
                    <a class="erp-forgot-link" href="${url.loginResetCredentialsUrl}">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <circle cx="11" cy="11" r="6" />
                            <path d="m16 16 4 4" />
                        </svg>
                        <span>비밀번호 찾기</span>
                    </a>
                <#else>
                    <p class="erp-forgot-link erp-forgot-link-disabled">
                        <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <circle cx="11" cy="11" r="6" />
                            <path d="m16 16 4 4" />
                        </svg>
                        <span>비밀번호 찾기</span>
                    </p>
                </#if>
            </form>
            <script src="${url.resourcesPath}/js/erp-password-policy.js" defer></script>
        </main>
    </#if>
</@layout.registrationLayout>
