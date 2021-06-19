const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const bodyParser = require('body-parser')
const mongoose = require('mongoose')
const fs = require('fs');
const axios = require('axios');
/* ============================================================================================================================
Different db settings based on container or non container
const db = 'mongodb://root:$iloveblockchain@127.0.0.1:27017/pod?authSource=admin'
const db = 'mongodb://127.0.0.1:27017/pod'; // "docker run -itd -p 27017:27017 --name mongojain mongo" mongo running in docker and nodejs not running in docker container 
const db = 'mongodb://mongojain:27017/pod'; //mongo container running in docker and nodejs app running in docker
============================================================================================================================*/
const MONGO_CONTAINER_NAME = process.env.MONGO_CONTAINER_NAME
const MONGO_INITDB_ROOT_USERNAME = process.env.MONGO_INITDB_ROOT_USERNAME
const MONGO_INITDB_ROOT_PASSWORD = process.env.MONGO_INITDB_ROOT_PASSWORD
const MONGO_INITDB_DATABASE = process.env.MONGO_INITDB_DATABASE
console.log("Process.env", MONGO_CONTAINER_NAME, MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD, MONGO_INITDB_DATABASE )
// const db = `mongodb://${MONGO_INITDB_ROOT_USERNAME}:${encodeURIComponent(MONGO_INITDB_ROOT_PASSWORD)}@${MONGO_CONTAINER_NAME}:27017/${MONGO_INITDB_DATABASE}?authSource=admin`
const db = `mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@${MONGO_CONTAINER_NAME}:27017/${MONGO_INITDB_DATABASE}?authSource=admin`

app.use(bodyParser.json())

if(db == null || db == "") {
    // db = 'mongodb://root:$iloveblockchain@localhost:27017/pod?authSource=admin'  
    // db = 'mongodb://root:$iloveblockchain@127.0.0.1:27017/pod?authSource=admin'  
} 
console.log("====================================================")
console.log("process.env", process.env)
console.log("====================================================")
console.log("Database==URL", db)
// Database==URL mongodb://jain:pAssw0rd@mongojain:27017/pod?authSource=admin

const options = {
    //   sslCA: ca,
      useNewUrlParser: true,
    //   reconnectTries: Number.MAX_VALUE,
    //   reconnectInterval: 500,
      connectTimeoutMS: 10000,
      useUnifiedTopology: true,
    //   createIndexes: true
    };
    mongoose.connect(db, options).then( function() {
      console.log("MongoDb Connection succesfull...")
    })
      .catch( function(err) {
      console.error(err);
    });
// Define schema
var Schema = mongoose.Schema;
var breakfastSchema = new Schema({
    email: {type:String, required:true, unique:true},
    bananas: {
      type: Number,
      min: [2, 'Too few bananas'],
      max: 12,
      required: [true, 'Why no bananas?']
    },
    drink: {
      type: String,
      enum: ['Coffee', 'Tea', 'Water',]
    }
  });

  var SomeModel = mongoose.model('SomeModel', breakfastSchema );

  app.use(express.static(__dirname + "view"))

  app.get("/", (req,res,next)=>{
      res.sendFile(__dirname + "/view/index.html")
  })

  app.post("/breakfast", async (req,res,next)=>{
      const _Totalbananas = req.body.bananas;
      const _email = req.body.email;
      const _drink = req.body.drink;

      var breakfast = new SomeModel({
          bananas: _Totalbananas,
          email: _email,
          drink : _drink
      })
      try {
          let checkIfExist = await check_if_email_exist(_email)
          let saveInDatabase = await breakfast.save();
          return res.status(200).json({
              result: saveInDatabase
          })
      } catch (error) {
          if(error.errors) {
            return res.status(500).json({
                error: error.errors
            })
          }
         return res.status(500).json({
             error: error
         })
      }

  })

app.get("/breakfast/:email", async (req,res,next)=>{
    
    var _email = req.params.email;
    try {
        var getInfo = await SomeModel.find({email:_email})
        if(getInfo.length > 0){
            return res.status(200).json({
                result: getInfo[0]
            })
        }
        throw new Error(`No results found for this user [${_email}]`)
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            error: error.message
        })
    }
})

  const check_if_email_exist = async (_email)=>{
    return new Promise((resolve,reject)=>{
        SomeModel.find({email:_email}).then(function(result){
            if(result.length >0){
                reject(`${_email} already exist`)
            } else {
                resolve(`${_email} doesnt exist`)
            }
        }).catch(function(err){
            console.log("CatchError", err)
            reject("Database error")
        })
    })
  }


  app.get("/service-a",(req,res,next)=>{
    const got = require('got');

    axios.get('http://service-a/health')
    .then(response => {
        console.log(response.data.url);
        console.log(response.data.explanation);
        res.status(200).json({
            from: "node-app calling service-a health endpoint",
            message: response.data,
            anothermessage: response.data.explanation
        })
    })
    .catch(error => {
        console.log(error);
        res.status(500).json({
            error: error,
        })
    });  
   
  })


  app.listen(PORT, function(){
      console.log(`magik happens on http://localhost:${PORT}`)
  })