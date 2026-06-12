<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=false; section>
    <#if section = "form">
        <main class="erp-login-page erp-password-page">
            <#assign passwordErrorMessage = "">
            <#assign passwordConfirmErrorMessage = "">
            <#assign isUserInitiatedPasswordChange = isAppInitiatedAction?? && isAppInitiatedAction>
            <#if messagesPerField.existsError('password')>
                <#assign passwordErrorMessage = messagesPerField.get('password')>
            </#if>
            <#if messagesPerField.existsError('password-confirm')>
                <#assign passwordConfirmErrorMessage = messagesPerField.get('password-confirm')>
            </#if>
            <#assign toastMessage = "">
            <#assign toastType = "error">
            <#if passwordErrorMessage?has_content>
                <#assign toastMessage = passwordErrorMessage>
            <#elseif passwordConfirmErrorMessage?has_content>
                <#assign toastMessage = passwordConfirmErrorMessage>
            <#elseif message?has_content>
                <#assign rawMessage = message.summary?replace("<[^>]*>", "", "r")?trim>
                <#assign normalizedMessage = rawMessage?lower_case>
                <#assign toastMessage = rawMessage>
                <#assign toastType = message.type!'error'>
                <#if normalizedMessage?contains("update password") || normalizedMessage?contains("임시 비밀번호") || normalizedMessage?contains("서비스 이용")>
                    <#if isUserInitiatedPasswordChange>
                        <#assign toastMessage = "">
                    <#else>
                        <#assign toastMessage = "서비스를 계속 이용하려면, 비밀번호를 재설정해야 합니다.">
                        <#assign toastType = "error">
                    </#if>
                </#if>
            </#if>
            <#if toastMessage?has_content>
                <#if toastType != "success" && toastType != "info">
                    <#assign toastType = "error">
                </#if>
                <div class="erp-toast erp-toast-${toastType}" role="alert" aria-live="assertive">
                    <span class="erp-toast-icon" aria-hidden="true"><#if toastType == "success">i<#else>!</#if></span>
                    <span>${kcSanitize(toastMessage)?no_esc}</span>
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
                            aria-describedby="input-error-password erp-policy-error"
                            aria-invalid="<#if passwordErrorMessage?has_content>true</#if>"
                        />
                        <button
                            class="erp-password-toggle"
                            type="button"
                            data-password-toggle="password-new"
                            data-show-label="새 비밀번호 보기"
                            data-hide-label="새 비밀번호 숨기기"
                            aria-label="새 비밀번호 보기"
                            aria-pressed="false"
                            title="새 비밀번호 보기"
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
                    <#if passwordErrorMessage?has_content>
                        <p id="input-error-password" class="erp-field-error" aria-live="polite">
                            ${kcSanitize(passwordErrorMessage)?no_esc}
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
                            aria-describedby="input-error-password-confirm"
                            aria-invalid="<#if passwordConfirmErrorMessage?has_content>true</#if>"
                        />
                        <button
                            class="erp-password-toggle"
                            type="button"
                            data-password-toggle="password-confirm"
                            data-show-label="새 비밀번호 확인 보기"
                            data-hide-label="새 비밀번호 확인 숨기기"
                            aria-label="새 비밀번호 확인 보기"
                            aria-pressed="false"
                            title="새 비밀번호 확인 보기"
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
                    <p
                        id="input-error-password-confirm"
                        class="erp-field-error"
                        aria-live="polite"
                        <#if !passwordConfirmErrorMessage?has_content>hidden</#if>
                        <#if passwordConfirmErrorMessage?has_content>data-server-error="true"</#if>
                    ><#if passwordConfirmErrorMessage?has_content>${kcSanitize(passwordConfirmErrorMessage)?no_esc}</#if></p>
                </div>

                <div class="erp-policy-box" aria-label="Password policy">
                    <div class="erp-policy-item" data-policy="length" data-policy-message="8자 이상 입력해 주세요." aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>8자 이상</span>
                    </div>
                    <div class="erp-policy-item" data-policy="letter" data-policy-message="영문을 1자 이상 포함해 주세요." aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>영문 포함</span>
                    </div>
                    <div class="erp-policy-item" data-policy="number" data-policy-message="숫자를 1자 이상 포함해 주세요." aria-checked="false">
                        <span class="erp-policy-dot" aria-hidden="true"></span>
                        <span>숫자 포함</span>
                    </div>
                </div>
                <p
                    id="erp-policy-error"
                    class="erp-policy-error"
                    aria-live="polite"
                    <#if !passwordErrorMessage?has_content>hidden</#if>
                    <#if passwordErrorMessage?has_content>data-server-error="true"</#if>
                ><#if passwordErrorMessage?has_content>${kcSanitize(passwordErrorMessage)?no_esc}</#if></p>

                <button class="erp-login-button erp-password-submit" name="login" id="kc-password-submit" type="submit">변경</button>
                <#if isUserInitiatedPasswordChange>
                    <button
                        class="erp-cancel-button"
                        type="submit"
                        name="cancel-aia"
                        value="true"
                        formnovalidate
                        data-skip-password-validation="true"
                    >취소</button>
                </#if>
            </form>
            <script src="${url.resourcesPath}/js/erp-password-policy.js" defer></script>
        </main>
    </#if>
</@layout.registrationLayout>
