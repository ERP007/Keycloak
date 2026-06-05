<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "form">
        <main class="erp-login-page erp-reset-page">
            <#if message?has_content>
                <#assign rawMessage = message.summary?replace("<[^>]*>", "", "r")?trim>
                <#assign normalizedMessage = rawMessage?lower_case>
                <#assign toastMessage = rawMessage>
                <#assign toastType = message.type!'error'>
                <#if normalizedMessage?contains("email") && normalizedMessage?contains("sent")>
                    <#assign toastMessage = "입력한 이메일로 비밀번호 재설정 링크를 보냈습니다.">
                    <#assign toastType = "success">
                <#elseif normalizedMessage?contains("invalid") || normalizedMessage?contains("not found")>
                    <#assign toastMessage = "입력한 정보를 다시 확인해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?contains("missing") || normalizedMessage?contains("please specify")>
                    <#assign toastMessage = "이메일을 입력해 주세요.">
                    <#assign toastType = "error">
                <#elseif normalizedMessage?matches(".*[a-zA-Z].*")>
                    <#assign toastMessage = "요청 처리 중 문제가 발생했습니다. 다시 시도해 주세요.">
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

            <section class="erp-brand erp-reset-brand" aria-label="ERP password reset">
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

            <form id="kc-reset-password-form" class="erp-login-card erp-reset-card" action="${url.loginAction}" method="post">
                <div class="erp-reset-copy">
                    <h2>비밀번호 찾기</h2>
                    <p>가입 시 등록한 이메일을 입력하시면<br />비밀번호 재설정 링크를 보내드립니다.</p>
                </div>

                <div class="erp-field">
                    <label for="username">이메일</label>
                    <div class="erp-input-wrap">
                        <svg class="erp-input-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <path d="M4 6h16v12H4z" />
                            <path d="m4 7 8 6 8-6" />
                        </svg>
                        <input
                            id="username"
                            name="username"
                            type="email"
                            placeholder="name@hyundaiparts.com"
                            autocomplete="email"
                            autofocus
                        />
                    </div>
                </div>

                <button class="erp-login-button erp-reset-submit" type="submit">재설정 링크 보내기</button>

                <a class="erp-back-link" href="${url.loginUrl}">
                    <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                        <path d="m15 18-6-6 6-6" />
                    </svg>
                    <span>로그인으로 돌아가기</span>
                </a>
            </form>

            <p class="erp-reset-help">메일이 오지 않으면 스팸함을 확인하거나 관리자에게 문의</p>
        </main>
    </#if>
</@layout.registrationLayout>
