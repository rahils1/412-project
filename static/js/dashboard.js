document.addEventListener("DOMContentLoaded", createDashboard);

async function createDashboard() {
    // Set the top welcome text
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

    // Populating the table body based on user's household id
    const res = await fetch("http://127.0.0.1:5000/dashboard_load_data", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    data = await res.json();
    console.log(data);

    const tbody = document.getElementById("tbody");
    for (const element of data) {
        tbody.innerHTML += `<tr>
                                <td>${element.listname}</td> <td>${element.isstocklist}</td>
                            </tr>`;
    }

    // TODO: Only show the Edit members button IF the user is an admin.
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
