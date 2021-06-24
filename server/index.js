//finally in Index.js 
const app = require('express')();
require('dotenv').config();
const port = process.env.PORT;
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const upload = multer({dest: __dirname + '/uploads/images'});
mongoose.Promise = global.Promise;
mongoose.connect(process.env.DATABASE, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true })
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
app.post('/api/stadium/save', upload.single('file'), async (req, res) => {
    console.log(req.body)
    var file = __dirname + '/' + req.body.data.filename;
    fs.rename(req.file.path, file, async function(err) {
        if (err) {
        console.log(err);
        res.send(500);
        } else {
        const stadium = new Stadium(req.body);
        await stadium.save((err, doc) => {
        if (err) {
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
            return res.status(200).json({
                success: true,
                message: 'Successfully Signed Up',
                stadiumData
           })
       }
   });
   res.json({
    message: 'File uploaded successfully',
    filename: req.file.filename
   });
  }})});
app.get('/api/stadium/all', getAllStadiums);
app.get('/api/stadium/:id', getStadiumDetails);
app.post('/api/stadium/reserve', ReserveStadium);
//app.post('/api/event/add', SaveEvent)
//boutique 
app.post('/upload', upload.single('photo'), (req, res) => {
    if(req.file) {
        res.json(req.file);
    }
    else throw 'error';
    
    // File input field name is simply 'file'
    
});