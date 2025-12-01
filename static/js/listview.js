let currentListId = null;

document.addEventListener("DOMContentLoaded", () => {
    const params = new URLSearchParams(window.location.search);
    const idParam = params.get("id");
    currentListId = parseInt(idParam);

    if (currentListId === null || isNaN(currentListId)) {
        alert("No list selected");
        window.location.href = "http://127.0.0.1:5000/dashboard";
        return;
    }

    loadListDetails();
    loadCategories();
});

async function loadListDetails() {
    const response = await fetch(`http://127.0.0.1:5000/getListEntries/${currentListId}`, {
        method: "GET",
        credentials: 'include',
        headers: { "Content-Type": "application/json" }
    });

    if (response.status === 200) {
        const data = await response.json();
        document.getElementById("list_title").textContent = data.listName;
        document.getElementById("list_info").textContent = `Items in "${data.listName}"`;
        const tbody = document.getElementById("listTable_tbody");
        tbody.innerHTML = "";
        data.entries.forEach(entry => {
            tbody.innerHTML += `<tr>
                <td>${entry.groceryName}</td>
                <td>${entry.category}</td>
                <td>${entry.quantity}</td>
                <td><button onclick="removeEntry(${entry.entryId})">Remove</button></td>
            </tr>`;
        });
    } else {
        alert("Failed to load list");
        window.location.href = "http://127.0.0.1:5000/dashboard";
    }
}

async function removeEntry(entryId) {
    const response = await fetch(`http://127.0.0.1:5000/deleteEntry/${entryId}`, {
        method: "DELETE",
        credentials: 'include',
        headers: { "Content-Type": "application/json" }
    });

    if (response.status === 200) {
        loadListDetails();
    } else {
        alert("Failed to remove item");
    }
}

async function loadCategories() {
    try {
        const response = await fetch(`http://127.0.0.1:5000/getCategories`, {
            method: "GET",
            credentials: 'include',
            headers: { "Content-Type": "application/json" }
        });

        if (response.status === 200) {
            const categories = await response.json();
            const categorySelect = document.getElementById("categorySelect");

            categories.forEach(category => {
                const option = document.createElement("option");
                option.value = category.c_categoryid;
                option.textContent = category.c_categoryname;
                categorySelect.appendChild(option);
            });
        }
    } catch (err) {
        console.log("Error loading categories:", err);
    }
}

function openAddItem() {
    document.getElementById("addItem").style.display = "block";
}

function closeAddItem() {
    document.getElementById("addItem").style.display = "none";
    document.getElementById("groceryName").value = "";
    document.getElementById("quantity").value = "1";
    document.getElementById("categorySelect").value = "";
}

function openDeleteList() {
    document.getElementById("deleteList").style.display = "block";
}

function closeDeleteList() {
    document.getElementById("deleteList").style.display = "none";
}

async function deleteList() {
    const response = await fetch(`http://127.0.0.1:5000/deleteList/${currentListId}`, {
        method: "DELETE",
        credentials: 'include',
        headers: { "Content-Type": "application/json" }
    });

    if (response.status === 200) {
        window.location.href = "http://127.0.0.1:5000/dashboard"
    } else {
        alert("Failed to Delete List");
    }
}

async function addItemToList() {
    const groceryName = document.getElementById("groceryName").value;
    let quantity = document.getElementById("quantity").value;
    const categoryId = document.getElementById("categorySelect").value;

    if (!groceryName || groceryName.trim() === "") {
        alert("Please enter a grocery name");
        return;
    }

    if (!quantity || quantity === "") {
        quantity = "1";
    }

    try {
        const response = await fetch(`http://127.0.0.1:5000/addEntry`, {
            method: "POST",
            credentials: 'include',
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                listId: currentListId,
                groceryName: groceryName,
                quantity: parseInt(quantity),
                categoryId: categoryId ? parseInt(categoryId) : null,
            })
        });

        const data = await response.json();

        if (response.status === 200) {
            closeAddItem();
            loadListDetails();
        } else {
            alert("Error: Failed to add item");
        }
    } catch (err) {
        alert("Error adding item to list");
    }
}
