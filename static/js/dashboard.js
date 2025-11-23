document.addEventListener("DOMContentLoaded", createDashboard);

async function createDashboard() {
    let welcome_text = document.getElementById("welcome_text");
    let result = await fetch("http://127.0.0.1:5000/currUser", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    if (result.status !== 200) {
        return;
    }

    let data = await result.json();
    let user = data.user;
    welcome_text.textContent = `Welcome ${user.username} to Household ${user.householdid}!`;
}


async function logout() {
    let result = await fetch("http://127.0.0.1:5000/logout", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    if (result.status === 200) {
        window.location.href = "/";
    }
}
