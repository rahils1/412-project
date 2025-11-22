const tableSelect = document.getElementById("tables");
const thead = document.getElementById("thead");
const tbody = document.getElementById("tbody");

tableSelect.addEventListener("change", async () => {
    const tableName = tableSelect.value;
    if (!tableName) return;

    const res = await fetch(`http://127.0.0.1:5000/table/${tableName}`);
    const data = await res.json();

    if (!Array.isArray(data) || data.length === 0) {
        thead.innerHTML = "";
        tbody.innerHTML = "<tr><td colspan='10'>No data</td></tr>";
        return;
    }

    const headers = Object.keys(data[0]);
    thead.innerHTML = "<tr>" + headers.map(h => `<th>${h}</th>`).join("") + "</tr>";

    tbody.innerHTML = data.map(row => {
        return "<tr>" + headers.map(h => `<td>${row[h]}</td>`).join("") + "</tr>";
    }).join("");
});
