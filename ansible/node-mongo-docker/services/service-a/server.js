const express = require('express');
const app = express();
const PORT = process.env.PORT || 80;
const bodyParser = require('body-parser')
const fs = require('fs');
const axios = require('axios');


app.get('/', (req,res,next)=>{
    res.status(200).json({
        message: "Service A Hello"
    })
})


app.get('/health', (req,res,next)=>{
    res.status(200).json({
        message: "Service A Healthy"
    })
})



app.get('/ping', (req,res,next)=>{
    res.status(200).json({
        message: "Service A response with pong"
    })
})

app.get("/service-b",(req,res,next)=>{
    axios.get('http://service-b/health')
    .then(response => {
        console.log(response.data.url);
        console.log(response.data.explanation);
        res.status(200).json({
            from: "serva-> call to service->b",
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
app.get("/service-c",(req,res,next)=>{
    axios.get('http://service-c/health')
    .then(response => {
        console.log(response.data.url);
        console.log(response.data.explanation);
        res.status(200).json({
            from: "serva-> call to service->c",
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