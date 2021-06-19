db.auth('jain', 'pAssw0rd')
db = db.getSiblingDB('pod')
db.createUser({
  user: 'jain',
  pwd: 'pAssw0rd',
  roles: [
    {
      role: 'readWrite',
      db: 'pod',
    },
  ],
});

//  inside yhour container when you login 
// mongo -u jain -p pAssw0rd

// db.createUser(
//     {
//         user: "root", 
//         pwd: "root", 
//         roles:["root"]
//     }
// );

// db.createUser(
//     {
//         user: "jain",
//         pwd: "pAssw0rd",
//         roles: [
//             {
//                 role: "readWrite",
//                 db: "pod"
//             }
//         ]
//     }
// );