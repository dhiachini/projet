//finally in Index.js 
const app = require('express')();
require('dotenv').config();
const port = process.env.PORT;
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
mongoose.Promise = global.Promise;
mongoose.connect(process.env.DATABASE, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true })
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());
app.listen(port, () => {
    console.log(`Server running at here ${port}`);
});
const { auth } = require('./middleware/auth')
const { RegisterUser, LoginUser, LogoutUser, getUserDetails } = require('./controller/AuthController');
const { GetStadiumLocation, SaveStadium, getAllStadiums, getStadiumDetails } = require('./controller/StadiumController');

app.post('/api/users/register', RegisterUser);
app.post('/api/users/login', LoginUser);
app.get('/api/users/get', auth, getUserDetails);
app.get('/api/users/logout', auth, LogoutUser);

app.get('/api/stadium/location', auth, GetStadiumLocation);
app.post('/api/stadium/save', SaveStadium);
app.get('/api/stadium/all', getAllStadiums);
app.get('/api/stadium/:id', getStadiumDetails)