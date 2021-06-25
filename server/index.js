//finally in Index.js 
const app = require('express')();
require('dotenv').config();
const port = process.env.PORT;
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const fs = require('fs');
const path = require('path')
const { Stadium } = require('./models/StadiumModel')
mongoose.Promise = global.Promise;
mongoose.connect(process.env.DATABASE, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true })
// app.use((req, res, next) => {
//     res.header('Access-Control-Allow-Origin', '*');
//     next();
// });
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(cookieParser());
app.use(cors());
app.listen(port, () => {
    console.log(`Server running at here ${port}`);
});
const { auth } = require('./middleware/auth')
const { RegisterUser, LoginUser, LogoutUser, getUserDetails } = require('./controller/AuthController');
const { GetStadiumLocation, SaveStadium, getAllStadiums, getStadiumDetails, ReserveStadium } = require('./controller/StadiumController');

//user
app.post('/api/users/register', RegisterUser);
app.post('/api/users/login', LoginUser);
app.get('/api/users/get', auth, getUserDetails);
app.get('/api/users/logout', auth, LogoutUser);
//stadiul
app.get('/api/stadium/location', auth, GetStadiumLocation);


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './uploads/');
    },
    filename: function (req, file, cb) {
        cb(null, new Date().toISOString() + file.originalname);
    }
});

const fileFilter = (req, file, cb) => {
    // reject a file
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
        cb(null, true);
    } else {
        cb(null, false);
    }
};

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 1024 * 1024 * 5
    },
    fileFilter: fileFilter
});
app.post('/api/stadium/save', upload.single('photo'), async (req, res) => {
    console.log("BODYYYYYYYYYYYY")
    console.log(req.body)
    var file = __dirname + '/' + req.file.path;
    console.log("FILEEEEEEEEEEEEE")
    console.log(req.file)
    fs.rename(req.file.path, file, async function (err) {
        if (err) {
            console.log(err);
            res.send(500);
        } else {
            req.body.picPath = req.file.path
            req.body.rating = 0;
            const positions = {
                lat: req.body.lat,
                lng: req.body.lng
            }
            req.body.assign(positions)
            const stadium = new Stadium(req.body);
            await stadium.save((err, doc) => {
                if (err) {
                    console.log(err);
                    return res.status(422).json({ errors: err })
                } else {
                    const stadiumData = {
                        name: doc.name,
                        description: doc.description,
                        price: doc.price,
                        rating: doc.rating,
                        picPath: doc.picPath,
                        positions: {
                            lat: doc.positions.lat,
                            lng: doc.positions.lng
                        }
                    }
                    console.log("somedata has been returned")
                    return res.json({
                        success: true,
                        message: 'Successfully Signed Up',
                        stadiumData
                    })
                }
            });
        }
    })
});
app.get('/api/stadium/all', getAllStadiums);
app.get('/api/stadium/:id', getStadiumDetails);
app.post('/api/stadium/reserve', ReserveStadium);
//app.post('/api/event/add', SaveEvent)
//boutique 
app.post('/upload', upload.single('photo'), (req, res) => {
    if (req.file) {
        res.json(req.file);
    }
    else throw 'error';

    // File input field name is simply 'file'

});