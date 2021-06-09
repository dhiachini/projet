const { Stadium } = require('../models/StadiumModel');

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
    console.log(stadiumDetail[0]);
    return res.status(200).json({
        success: true,
        stadium: stadiumDetail[0]
    });
}

exports.getAllStadiums = async (req, res) => {
    const docs = await Stadium.find({});
    console.log("Docs has been returned : " + docs.length);
    return res.status(200).json({ success: true, data: docs });
}

exports.SaveStadium = async (req, res) => {
    const stadium = new Stadium(req.body);
    await stadium.save((err, doc) => {
        if (err) {
            return res.status(422).json({ errors: err })
        } else {
            const userData = {
                name: doc.name,
                description: doc.description,
                rating: doc.rating,
                price: doc.price,
                positions: {
                    lat: doc.positions.lat,
                    lng: doc.positions.lng
                }
            }
            return res.status(200).json({
                success: true,
                message: 'Successfully Signed Up',
                userData
            })
        }
    });
}
