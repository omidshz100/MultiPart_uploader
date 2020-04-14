# MultiPart_uploader
swift code for uploading multi part file with post method

You can use any file like : 
⋅⋅*Zip
⋅⋅*MKV
⋅⋅*AVI
⋅⋅*PNG
⋅⋅*Jpeg
⋅⋅* ...

Despite the file parameter name is images

***Example of using this code for swift 5:***

```swift
let url = Bundle.main.path(forResource: "pic", ofType: "png")
let img = UIImage(contentsOfFile: url!)

let url2 = Bundle.main.path(forResource: "pic2", ofType: "png")
let img2 = UIImage(contentsOfFile: url2!)


let rec = Multi_part_Uploader()
rec.request(stringUrl: "url String", parameters: ["key1":"value1","key2":"value2"], imageNames: ["file name with typeName","file name with typeName"], images: [fileData, fileData ) { an, err , bl in
    
    print(bl)
    print("----")
    print(err)
}
```
