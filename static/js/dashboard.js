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
    let res = await fetch("http://127.0.0.1:5000/listTable_load_data", {
        method: "GET",
        headers: { "Content-Type": "application/json" },
    });

    data = await res.json();

    var tbody = document.getElementById("listTable_tbody");
    for (const element of data) {
        tbody.innerHTML += `<tr>
                                <td>${element.listname}</td> <td>${element.isstocklist}</td>
                            </tr>`;
    }

    // TODO: Only show the Edit members button IF the user is an admin.
    // Populate the user table based on user's household id 
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

    // Once the user table is populated we can display the number of members
    const userTableHeader = document.getElementById("userTable_header")
    userTableHeader.innerHTML += calculateNumRows("userTable_tbody")
}

// Used to calculate the total # of rows in a tbody
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
