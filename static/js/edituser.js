async function addUser() {
    const userName = document.querySelector('input[type="text"]').value;

    const response = await fetch("http://127.0.0.1:5000/adduser", {
        method: "POST",
        credentials: 'include',
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            userName: userName,
        })
    });

    if (response.status === 200) {
        window.location.href = "http://127.0.0.1:5000/dashboard";
    } else {
        alert("Failed to add user " + response.status);
    }
}
