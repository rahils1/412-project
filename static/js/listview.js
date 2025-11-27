let currentListId = null;

document.addEventListener("DOMContentLoaded", () => {
    console.log("Current URL:", window.location.href);
    const params = new URLSearchParams(window.location.search);
    const idParam = params.get("id");
    console.log("ID parameter from URL:", idParam);
    currentListId = parseInt(idParam);
    console.log("Current List ID (parsed):", currentListId);
    
    if (currentListId === null || isNaN(currentListId)) {
        alert("No list selected");
        window.location.href = "http://127.0.0.1:5000/dashboard";
        return;
    }
    
    loadListDetails();
    loadCategories();
});

async function loadListDetails() {
    // Fetch list entries from backend
    const response = await fetch(`http://127.0.0.1:5000/getListEntries/${currentListId}`, {
        method: "GET",
        credentials: 'include',
        headers: { "Content-Type": "application/json" }
    });

    if (response.status === 200) {
        const data = await response.json();
        
        // Update title
        document.getElementById("list_title").textContent = data.listName;
        document.getElementById("list_info").textContent = `Items in "${data.listName}"`;

        // Populate table
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

// Remove entry from list
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

async function addItemToList() {
    const groceryName = document.getElementById("groceryName").value;
    let quantity = document.getElementById("quantity").value;
    const categoryId = document.getElementById("categorySelect").value;

    if (!groceryName || groceryName.trim() === "") {
        alert("Please enter a grocery name");
        return;
    }

    // Default quantity to 1 if empty
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
            alert("Error: " + (data.error || "Failed to add item"));
        }
    } catch (err) {
        console.log("Error adding item:", err);
        alert("Error adding item to list");
    }
}
