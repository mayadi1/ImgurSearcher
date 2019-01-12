
#ImgurSearcher

1. Provide a search field for user input.
2. Make a get request to Imgur's API to search for photos for with the term from the search field
3. Display the results for the given search terms, including the image and title.
4. Load the next page when user scrolls to the end of the list.
5. When the user clicks on an Image open the Image in a new view include the title in a navigation bar.
6. Add the header "Authorization: Client­ID 126701cd8332f32" to each request
7. Base URL is https://api.imgur.com/3/gallery/search/time/{page number}?q={search parameters}
8. Use the gallery search endpoint in Imgur. An example request:
curl ­X GET https://api.imgur.com/3/gallery/search/time/1?q=cats ­H "Authorization: Client­ID 126701cd8332f32" ­v
