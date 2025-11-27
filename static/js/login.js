async function logIn() {
    let username = document.getElementById("username_input");
    let password = document.getElementById("password_input");
    let error_text = document.getElementById("error_text");

    let result = await fetch("http://127.0.0.1:5000/login", {
        method: "POST",
        credentials: 'include',
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            username: username.value,
            password: password.value
        })
    });
    if (result.status === 200) {
        let data = await result.json();
        console.log(data);
        window.location.href = "http://127.0.0.1:5000/dashboard";
    } else {
        error_text.textContent = "Login failed: Invalid username or password";
    }
}
