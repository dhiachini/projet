window.onload = () => {
    let button = document.getElementById('sub');
    button.addEventListener('click', async (e) => {
        e.preventDefault;
        let email = document.getElementById('email').value;
        let password = document.getElementById('pass').value;

        await fetch('http://localhost:3000/api/users/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({
                email,
                password
            }
            ), mode: "cors"
        })
            .then(res => res.json())
            .then((res) => {
                console.log(res);
                window.location.replace("./index.html");
            })
            .catch(err => console.log(err))
    });
}