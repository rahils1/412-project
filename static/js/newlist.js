// Toggle the stock list switch
function toggleSwitch(div) {
    div.classList.toggle("active");
    div.dataset.state = div.classList.contains("active") ? "yes" : "no";
}

// Send list creation data to backend
async function createList() {
    const listName = document.querySelector('input[type="text"]').value;
    const comment = document.querySelector('textarea').value;
    const isStockList = document.querySelector('.toggle-container').dataset.state === "yes";

    const response = await fetch("http://127.0.0.1:5000/createList", {
        method: "POST",
        credentials: 'include',
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            listName: listName,
            comment: comment,
            isStockList: isStockList
        })
    });

    if (response.status === 200) {
        window.location.href = "http://127.0.0.1:5000/dashboard";
    } else {
        alert("Failed to create list");
    }
}
