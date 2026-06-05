(function () {
    var newPasswordInput = document.getElementById("password-new");
    var policyItems = document.querySelectorAll("[data-policy]");

    if (!newPasswordInput || policyItems.length === 0) {
        return;
    }

    function setPolicyState(policy, checked) {
        var item = document.querySelector('[data-policy="' + policy + '"]');

        if (!item) {
            return;
        }

        item.classList.toggle("is-checked", checked);
        item.setAttribute("aria-checked", checked ? "true" : "false");
    }

    function updatePolicyState() {
        var newPassword = newPasswordInput.value;

        setPolicyState("length", newPassword.length >= 8);
        setPolicyState("letter", /[A-Za-z]/.test(newPassword));
        setPolicyState("number", /\d/.test(newPassword));
    }

    newPasswordInput.addEventListener("input", updatePolicyState);
    updatePolicyState();
})();
