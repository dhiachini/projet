const { Reservation } = require('../models/ReservationModel');
const { Stadium } = require('../models/StadiumModel');
const uuidv4 = require('uuidv4')
const multer = require('multer')
const path = require('path')

const handleError = (err, res) => {
  res
    .status(500)
    .contentType("text/plain")
    .end("Oops! Something went wrong!");
};




 
const storage = multer.diskStorage({
    destination (req, file, cb) {
        cb(null, process.env.UPLOAD_DIR);
    },
    filename (req, file, cb) {
        cb(null, uuidv4().concat ('-').concat(file.originalname));
    }
});

const fileFilter = (req, file, cb) => {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png' || file.mimetype === 'image/jpg') {
        cb(null, true);
    } else {
        cb(null, false);
    }
};

const upload = multer({
    storage,
    fileFilter,
    limits: {
        fileSize: 1024 * 1024 * 10
    }
});

exports.GetStadiumLocation = (req, res) => {
    const { minLat, maxLat, minLng, maxLng } = req.body;
    const docs = Stadium.find({
        'postions.lat': { $gte: maxLat },
        'postions.lng': { $lte: minLat }
    });
    console.log("Stadium found minLat, maxLat : ");
    console.log(docs);
    return res.status(400).json({ success: true, data: docs });
}

exports.getStadiumDetails = async (req, res) => {
    console.log(req.params.id);
    const stadiumDetail = await Stadium.find({ _id: req.params.id });
    return res.status(200).json({
        success: true,
        stadium: stadiumDetail[0]
    });
}

exports.getAllStadiums = async (req, res) => {
    const docs = await Stadium.find({});
    return res.status(200).json({ success: true, data: docs });
}


exports.ReserveStadium = async (req, res) => {
    console.log(req.body)
    if (req.body.sid != undefined && req.body.uid != undefined) {
        let reservation = await Reservation(req.body).save();
        res.status(200).json({
            success: true,
            reservation
        })
    }
    else {
        res.status(500).json({
            success: false,
            message: "Should specify the ids",
            error: 0
        })
    }
}

exports.SaveStadium = (upload.single('files'), async (req, res) => {
    console.log(req.file);
    console.log(req.body);
        const now = Date.now();
      const tempPath = req.file.path;
      const targetPath = path.join(__dirname, "./uploads/"+now+".png");
  
      if (path.extname(req.file.originalname).toLowerCase() === ".png" || path.extname(req.file.originalname).toLowerCase() === ".jpeg" || path.extname(req.file.originalname).toLowerCase() === ".jpg") {
        fs.rename(tempPath, targetPath, async  err => {
          if (err) return handleError(err, res);
  
       
    req.body.picPath = targetPath;
    req.body.rating = 0
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
});
} else {
    fs.unlink(tempPath, err => {
      if (err) return handleError(err, res);

      res
        .status(403)
        .contentType("text/plain")
        .end("Only .png files are allowed!");
    });
  }
}
);