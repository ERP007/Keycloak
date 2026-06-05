<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "form">
        <main class="erp-login-page erp-password-page">
            <#if message?has_content>
                <div class="erp-toast erp-toast-error" role="alert" aria-live="assertive">
                    <span class="erp-toast-icon" aria-hidden="true">!</span>
                    <span>서비스 이용을 계속하려면, 임시 비밀번호를 변경 후 이용 가능합니다.</span>
                </div>
            </#if>

            <section class="erp-password-brand" aria-label="Password update">
                <h1>비밀번호 변경</h1>
            </section>

            <form id="kc-passwd-update-form" class="erp-login-card erp-password-card" action="${url.loginAction}" method="post">
                <input
                    id="username"
                    name="username"
                    type="text"
                    value="${(username!'')}"
                    autocomplete="username"
                    readonly
                    hidden
                />

                <div class="erp-field">
                    <label for="password-new">새 비밀번호</label>
                    <div class="erp-input-wrap">
                        <svg class="erp-input-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <rect x="5" y="10" width="14" height="11" rx="2" />
                            <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                        </svg>
                        <input
                            id="password-new"
                            name="password-new"
                            type="password"
                            placeholder="••••••••"
                            autocomplete="new-password"
                            autofocus
                            aria-invalid="<#if messagesPerField.existsError('password')>true</#if>"
                        />
                        <svg class="erp-eye-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" />
                            <circle cx="12" cy="12" r="3" />
                        </svg>
                    </div>
                    <#if messagesPerField.existsError('password')>
                        <p id="input-error-password" class="erp-field-error" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </p>
                    </#if>
                </div>

                <div class="erp-field">
                    <label for="password-confirm">새 비밀번호 확인</label>
                    <div class="erp-input-wrap">
                        <svg class="erp-input-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <rect x="5" y="10" width="14" height="11" rx="2" />
                            <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                        </svg>
                        <input
                            id="password-confirm"
                            name="password-confirm"
                            type="password"
                            placeholder="••••••••"
                            autocomplete="new-password"
                            aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />
                        <svg class="erp-eye-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                            <path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" />
                            <circle cx="12" cy="12" r="3" />
                        </svg>
                    </div>
                    <#if messagesPerField.existsError('password-confirm')>
                        <p id="input-error-password-confirm" class="erp-field-error" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </p>
                    </#if>
                </div>

                <div class="erp-policy-box" aria-label="Password policy">
                    <div class="erp-policy-item" data-policy="length" aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>8자 이상</span>
                    </div>
                    <div class="erp-policy-item" data-policy="letter" aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>영문 포함</span>
                    </div>
                    <div class="erp-policy-item" data-policy="number" aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>숫자 포함</span>
                    </div>
                </div>

                <button class="erp-login-button erp-password-submit" name="login" id="kc-password-submit" type="submit">변경</button>
                <#if isAppInitiatedAction??>
                    <button class="erp-cancel-button" type="submit" name="cancel-aia" value="true">취소</button>
                <#else>
                    <#assign cancelUrl = (url.loginRestartFlowUrl!'')>
                    <#if cancelUrl?has_content>
                        <a class="erp-cancel-button" href="${cancelUrl}">취소</a>
                    <#else>
                        <p class="erp-cancel-button erp-cancel-button-disabled">취소</p>
                    </#if>
                </#if>
            </form>
            <script src="${url.resourcesPath}/js/erp-password-policy.js" defer></script>
        </main>
    </#if>
</@layout.registrationLayout>
