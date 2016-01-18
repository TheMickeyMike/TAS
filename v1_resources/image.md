###Dodawanie zdjeca
```
curl -H 'Authorization: Bearer <token>' \
-F avatar=@ <zdj�cie>
-X POST http://localhost:3000/api/v1/images/upload_image
```

###Dodawanie plikow
```
curl -H 'Authorization: Bearer <token>' \
-F avatar=@ <plik>
-X POST http://localhost:3000/upload_document
```

###Usuwanie zdjecia
```
curl -H 'Authorization: Bearer <token>' \
-X DELETE http://localhost:3000/api/v1/images/delete_image/<image_id>
```

###Usuwanie Plikow
```
curl -H 'Authorization: Bearer <token>' \
-X DELETE http://localhost:3000/delete_document/<document_id>
```

###Dodawanie statusu ze zdjeciem
```
curl -H "Content-Type: application/json"
-H 'Authorization: Bearer <token>'
-d '{"content":"To jest moj nowy status z obrazem", "image_id":"<id obrazu>"}'
-X POST http://localhost:3000/api/v1/statuses/new
```

###Wyswietlanie wszytskich dodanych obrazow zalogowanego uzytkownika
```
curl -v -H 'Authorization: Bearer <token>'
-X GET http://localhost:3000/api/v1/images/show_all_img_for_user/all
```

###Pokaz wszystkie obrazy
```
#curl -H 'Authorization: Bearer <token>'
-X GET http://localhost:3000/api/v1/images/show_all_img
```