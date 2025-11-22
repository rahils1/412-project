async function logIn() {
    let username = document.getElementById("username_input");
    let password = document.getElementById("password_input");

    let result = await fetch("http://127.0.0.1:5000/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            username: username.value,
            password: password.value
        })
    });
    console.log(result.status);
    let data = await result.json();
    console.log(data);
}
