var methods = [];
for (var m in obj) {
    if (typeof obj[m] == "function") {
        methods.push(m);
    }
}
alert(methods.join(","));

/*
This way, you will get all methods that you can call on obj. This includes the methods that it "inherits" from its prototype (like getMethods() in java). If you only want to see those methods defined directly by obj you can check with hasOwnProperty:
*/
var methods = [];
for (var m in obj) {        
    if (typeof obj[m] == "function" && obj.hasOwnProperty(m)) {
        methods.push(m);
    }
}
alert(methods.join(","));
/*
The getOwnPropertyNames function can be used to enumerate over all properties of the passed in object, including those that are non-enumerable. Then a simple typeof check can be employed to filter out non-functions. Unfortunately, Chrome is the only browser that it works on currently.
*/
​function getAllMethods(object) {
    return Object.getOwnPropertyNames(object).filter(function(property) {
        return typeof object[property] == 'function';
    });
}

console.log(getAllMethods(Math));