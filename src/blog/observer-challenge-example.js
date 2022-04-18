// Make some accounts.
var accounts = [];
accounts.push({ name: "Bob", money: 100, labelView: null });
accounts.push({ name: "Cindy", money: 100, labelView: null });
accounts.push({ name: "Reginald", money: 100, labelView: null });
accounts.push({ name: "Jim Argalax", money: 100, labelView: null });
accounts.push({ name: "Valerian Vast", money: 100, labelView: null });
accounts.push({ name: "Archonicus Auriarch", money: 100, labelView: null });
// Add each account to the document. It will look like:
// Bob: 100 [Pay!]
accounts.forEach(function (account) {
    var row = myPage.appendChild(document.createElement("div"));
    row.appendChild(document.createTextNode(account.name + ":"));
    account.labelView = row.appendChild(document.createElement("span"));
    account.labelView.textContent = account.money;
    var payButton = row.appendChild(document.createElement("button"));
    payButton.textContent = "Pay!";
    payButton.onclick = function () {
        // Update account and then re-display.
        account.money = account.money + 10;
        account.labelView.textContent = account.money;
        // Note how we've captured the account object, and are modifying
        // it from inside this observer.
    };
});
var printSumButton = myPage.appendChild(document.createElement("button"));
printSumButton.textContent = "Print Total!";
printSumButton.onclick = function () {
    var sum = 0;
    for (var _i = 0, accounts_1 = accounts; _i < accounts_1.length; _i++) {
        var account = accounts_1[_i];
        sum += account.money;
    }
    alert("Sum: " + sum);
};
