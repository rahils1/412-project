document.addEventListener("DOMContentLoaded", createDashboard);

async function checkIfAdmin() {
    let res = await fetch("http://127.0.0.1:5000/currUser", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    data = await res.json();
    return data.user.isadmin;
}

async function createDashboard() {
    let welcome_text = document.getElementById("welcome_text");
    let result = await fetch("http://127.0.0.1:5000/currUser", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    if (result.status !== 200) { return; }

    let data = await result.json();
    let user = data.user;
    welcome_text.textContent = `Welcome ${user.username} to Household ${user.householdid}!`;

    let res = await fetch("http://127.0.0.1:5000/listTable_load_data", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    data = await res.json();

    var tbody = document.getElementById("listTable_tbody");
    for (const element of data) {
        const row = document.createElement("tr");
        row.innerHTML = `<td>${element.listname}</td><td>${element.isstocklist}</td>`;
        row.style.cursor = "pointer";
        row.onclick = () => {
            window.location.href = `http://127.0.0.1:5000/listview?id=${element.listid}`;
        };
        tbody.appendChild(row);
    }

    const admin_status = await checkIfAdmin();
    if (!admin_status) {
        const editBtn = document.getElementById("editMembersButton");
        editBtn.remove();
    }

    res = await fetch("http://127.0.0.1:5000/userTable_load_data", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    data = await res.json();

    var tbody = document.getElementById("userTable_tbody");
    for (const element of data) {
        tbody.innerHTML += `<tr>
                                <td>${element.username}</td>
                            </tr>`;
    }

    const userTableHeader = document.getElementById("userTable_header");
    userTableHeader.innerHTML += calculateNumRows("userTable_tbody");
}

function calculateNumRows(tbodyIdName) {
    const table = document.getElementById(tbodyIdName);
    return table.rows.length;
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
