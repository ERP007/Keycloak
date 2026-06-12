(function () {
    var newPasswordInput = document.getElementById("password-new");
    var confirmPasswordInput = document.getElementById("password-confirm");
    var submitButton = document.getElementById("kc-password-submit");
    var form = document.getElementById("kc-passwd-update-form");
    var policyError = document.getElementById("erp-policy-error");
    var confirmError = document.getElementById("input-error-password-confirm");
    var policyItems = document.querySelectorAll("[data-policy]");
    var passwordToggleButtons = document.querySelectorAll("[data-password-toggle]");
    var skipValidationSubmit = false;
    var hasServerPolicyError = policyError && policyError.getAttribute("data-server-error") === "true";
    var hasServerConfirmError = confirmError && confirmError.getAttribute("data-server-error") === "true";

    function forEachNode(nodes, callback) {
        for (var index = 0; index < nodes.length; index += 1) {
            callback(nodes[index], index);
        }
    }

    function setPasswordVisibility(input, button, visible) {
        var label = visible ? button.getAttribute("data-hide-label") : button.getAttribute("data-show-label");

        input.type = visible ? "text" : "password";
        button.classList.toggle("is-visible", visible);
        button.setAttribute("aria-pressed", visible ? "true" : "false");

        if (label) {
            button.setAttribute("aria-label", label);
            button.setAttribute("title", label);
        }
    }

    function bindPasswordToggle(button) {
        var inputId = button.getAttribute("data-password-toggle");
        var input = inputId ? document.getElementById(inputId) : null;

        if (!input) {
            return;
        }

        button.addEventListener("click", function () {
            setPasswordVisibility(input, button, input.type === "password");
            input.focus();
        });
    }

    forEachNode(passwordToggleButtons, bindPasswordToggle);

    if (!newPasswordInput || !confirmPasswordInput || !submitButton || policyItems.length === 0) {
        return;
    }

    var validationSkipButtons = document.querySelectorAll("[data-skip-password-validation]");

    forEachNode(validationSkipButtons, function (button) {
        button.addEventListener("click", function () {
            skipValidationSubmit = true;
        });
    });

    var policyChecks = {
        length: function (password) {
            return password.length >= 8;
        },
        letter: function (password) {
            return /[A-Za-z]/.test(password);
        },
        number: function (password) {
            return /\d/.test(password);
        }
    };

    function getPolicyMessage(policy) {
        var item = document.querySelector('[data-policy="' + policy + '"]');

        if (!item) {
            return "";
        }

        return item.getAttribute("data-policy-message") || "";
    }

    function setPolicyState(policy, checked, revealMissing) {
        var item = document.querySelector('[data-policy="' + policy + '"]');

        if (!item) {
            return;
        }

        item.classList.toggle("is-checked", checked);
        item.classList.toggle("is-missing", revealMissing && !checked);
        item.setAttribute("aria-checked", checked ? "true" : "false");
    }

    function getValidationState() {
        var newPassword = newPasswordInput.value;
        var confirmPassword = confirmPasswordInput.value;
        var policyState = {
            length: policyChecks.length(newPassword),
            letter: policyChecks.letter(newPassword),
            number: policyChecks.number(newPassword)
        };
        var missingPolicyMessages = [];
        var isPolicyValid = policyState.length && policyState.letter && policyState.number;
        var hasPasswordInput = newPassword.length > 0;
        var hasConfirmInput = confirmPassword.length > 0;
        var isConfirmValid = hasPasswordInput && hasConfirmInput && newPassword === confirmPassword;

        Object.keys(policyState).forEach(function (policy) {
            if (!policyState[policy]) {
                missingPolicyMessages.push(getPolicyMessage(policy));
            }
        });

        return {
            policyState: policyState,
            hasPasswordInput: hasPasswordInput,
            hasConfirmInput: hasConfirmInput,
            isPolicyValid: isPolicyValid,
            isConfirmValid: isConfirmValid,
            missingPolicyMessages: missingPolicyMessages.filter(Boolean),
            isReadyToSubmit: isPolicyValid && isConfirmValid
        };
    }

    function updatePolicyError(validation, revealMissing) {
        var keepServerError = hasServerPolicyError && !validation.hasPasswordInput && !validation.hasConfirmInput;

        if (!policyError) {
            return;
        }

        if (keepServerError) {
            policyError.hidden = false;
            return;
        }

        if (hasServerPolicyError && validation.hasPasswordInput) {
            hasServerPolicyError = false;
            policyError.removeAttribute("data-server-error");
        }

        if (!revealMissing || !validation.hasPasswordInput || validation.missingPolicyMessages.length === 0) {
            policyError.textContent = "";
            policyError.hidden = true;
            return;
        }

        policyError.textContent = "비밀번호 조건을 확인해 주세요: " + validation.missingPolicyMessages.join(" ");
        policyError.hidden = false;
    }

    function updateConfirmError(validation, revealConfirm) {
        var keepServerError = hasServerConfirmError && !validation.hasConfirmInput;

        if (!confirmError) {
            return;
        }

        if (keepServerError) {
            confirmError.hidden = false;
            confirmPasswordInput.setAttribute("aria-invalid", "true");
            return;
        }

        if (hasServerConfirmError && validation.hasConfirmInput) {
            hasServerConfirmError = false;
            confirmError.removeAttribute("data-server-error");
        }

        if (!revealConfirm || !validation.hasPasswordInput || !validation.isPolicyValid) {
            confirmError.textContent = "";
            confirmError.hidden = true;
            confirmPasswordInput.setAttribute("aria-invalid", "false");
            return;
        }

        if (!validation.hasConfirmInput) {
            confirmError.textContent = "새 비밀번호 확인을 입력해 주세요.";
            confirmError.hidden = false;
            confirmPasswordInput.setAttribute("aria-invalid", "true");
            return;
        }

        if (!validation.isConfirmValid) {
            confirmError.textContent = "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
            confirmError.hidden = false;
            confirmPasswordInput.setAttribute("aria-invalid", "true");
            return;
        }

        confirmError.textContent = "";
        confirmError.hidden = true;
        confirmPasswordInput.setAttribute("aria-invalid", "false");
    }

    function updatePolicyState(options) {
        var validation = getValidationState();
        var revealMissing = Boolean(options && options.revealMissing) || validation.hasPasswordInput;
        var revealConfirm = Boolean(options && options.revealConfirm) || validation.hasConfirmInput || validation.isPolicyValid;

        setPolicyState("length", validation.policyState.length, revealMissing && validation.hasPasswordInput);
        setPolicyState("letter", validation.policyState.letter, revealMissing && validation.hasPasswordInput);
        setPolicyState("number", validation.policyState.number, revealMissing && validation.hasPasswordInput);
        updatePolicyError(validation, revealMissing);
        updateConfirmError(validation, revealConfirm);

        submitButton.disabled = !validation.isReadyToSubmit;
    }

    function bindValidationEvents(input, revealConfirm) {
        ["input", "change", "keyup", "paste", "compositionend", "blur"].forEach(function (eventName) {
            input.addEventListener(eventName, function () {
                updatePolicyState({
                    revealMissing: true,
                    revealConfirm: revealConfirm
                });
            });
        });
    }

    bindValidationEvents(newPasswordInput, false);
    bindValidationEvents(confirmPasswordInput, true);

    if (form) {
        form.addEventListener("submit", function (event) {
            var submitter = event.submitter;
            var shouldSkipValidation = skipValidationSubmit ||
                (submitter && submitter.getAttribute("data-skip-password-validation") === "true");

            if (shouldSkipValidation) {
                skipValidationSubmit = false;
                return;
            }

            if (!getValidationState().isReadyToSubmit) {
                event.preventDefault();
                updatePolicyState({
                    revealMissing: true,
                    revealConfirm: true
                });
            }
        });
    }

    updatePolicyState({ revealMissing: false });
    window.setTimeout(function () {
        updatePolicyState({ revealMissing: false });
    }, 150);
    window.setTimeout(function () {
        updatePolicyState({ revealMissing: false });
    }, 600);
})();
