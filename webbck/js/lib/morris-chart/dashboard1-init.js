// Dashboard 1 Morris-chart
$( function () {
	"use strict";


	// Extra chart
	Morris.Area( {
		element: 'extra-area-chart',
		data: [ {
				period: 'Monday',
				iphone: 0,
				imac: 0,
        }, {
				period: 'Tuesday',
				iphone: 10,
				imac: 60,
        }, {
				period: 'Wednesday',
				iphone: 120,
				imac: 10,
        }, {
				period: 'Thursday',
				iphone: 0,
				imac: 0,
        }, {
				period: 'Friday',
				iphone: 0,
				imac: 0,
        }, {
				period: 'Saturday',
				iphone: 160,
				imac: 75,
        }, {
				period: 'Sunday',
				iphone: 10,
				imac: 120,
        }


        ],
		lineColors: [ '#26DAD2', '#fc6180' ],
		xkey: 'period',
		ykeys: [ 'iphone', 'imac'],
		labels: [ 'iphone', 'imac'],
		pointSize: 0,
		lineWidth: 0,
		resize: true,
		fillOpacity: 0.8,
		behaveLikeLine: true,
		gridLineColor: '#e0e0e0',
		hideHover: 'auto'

	} );



} );




// // Dashboard 1 Morris-chart
// $( function () {
// 	"use strict";


// 	// Extra chart
// 	Morris.Area( {
// 		element: 'extra-area-chart',
// 		data: [ {
// 				period: 'Monday',
// 				Match: 0,
//         }, {
// 				period: 'Tuesday',
// 				Match: 10,
//         }, {
// 				period: 'Wednesday',
// 				Match: 120,
//         },{
// 				period: 'Thursday',
// 				Match: 0,
// 		}, {
// 				period: 'Friday',
// 				Match: 10,
// 		}, {
// 				period: 'Saturday',
// 				Match: 120,
// 		}, {
// 				period: 'Sunday',
// 				Match: 120,
// 		}


//         ],
// 		lineColors: [ '#26DAD2' ],
// 		xkey: 'period',
// 		ykeys: [ 'Match', 'Event'],
// 		labels: [ 'Match', 'Event'],
// 		pointSize: 0,
// 		lineWidth: 0,
// 		resize: true,
// 		fillOpacity: 0.8,
// 		behaveLikeLine: true,
// 		gridLineColor: '#e0e0e0',
// 		hideHover: 'auto'

// 	} );



// } );
