## Table Of Contents
- [Forking the project](#forking-the-project)
- [Setting the project up locally](#setting-the-project-up-locally)
- [pub get](#pub-get)
- [Creating an upload keystore](#Creating-an-upload-keystore)
- [Creating a firebase Project](#horizontal-rule)
- [Enabling firebase](#lists)
- [Downloading the Firebase CLI](#links)
- [Seeting Up the emulators](#images)

---
<br />

## Forking the project
Forking the project is like making your own copy of the project.
To fork the project you are going to to go the main github [here](https://github.com/tadaspetra/conveneapp)
then clicking on the fork button on the top right
It should redirect you to the page of your fork.
<br />
<br>
<br />

## Setting the project up locally
To setup the project locally, we are going to use [Github Desktop](https://desktop.github.com/). So after you've downloaded github desktop, login into your GitHub account. Then press on file (top left) and clone repository. Click on the fork you just made and select the path of where you want to install it in the bottom textfield
<br />
<br>
<br />
## pub get
after its done cloning the repo, open the folder in vs code or your preferred code editor, and run a ``` flutter pub get``` to get download all the dependencies the project uses.
<br />
<br>
<br />

## Creating an upload keystore
OFFICIAL DOC ON HOW TO DO IT [HERE](https://docs.flutter.dev/deployment/android#signing-the-app)

To create an upload keystore, you'll need to have [Java](https://www.java.com/download/ie_manual.jsp) downloaded and in your path. 
in your terminal/powershell you need to run the following command
:
<br />
On Mac/Linux: 
<br />
```
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
On Windows:
```
  keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
#### AND REMEMBER TO CHANGE THE C:\Users\USER_NAME\upload-keystore.jks TO YOUR PREFERRED LOCATION 
<br />
<br />

Now when its done, you are going to create a `key.properties` file in the android folder of the convene app project and here is what to type:
```
storePassword='YOUR UPLOAD KEYSTORE PASSWORD'
keyPassword='THE KEY PASSWORD'
keyAlias=upload
storeFile='LOCATION OF THE KEYSTORE FILE YOU JUST CREATED'
```
After that, you're gonna simply go the `/android/app/build.gradle` in the project and Find the buildTypes block:
```
   buildTypes {
       release {
           // TODO: Add your own signing config for the release build.
           // Signing with the debug keys for now,
           // so `flutter run --release` works.
           signingConfig signingConfigs.debug
       }
   }
   ``` 
   and change it to:
   ```
      signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
   ``` 
And when you're done with that, run the project. It will throw many errors at you, but don't worry. This is because we're not done yet.
<br />
<br>
<br />
## Setting up firebase


## Links


<!-- 
    Example

    [1]: http://jamesqquick.com/ 
-->

Then use the reference style link by using your text inside of brackets followed by the link 'key' inside of bracket.

<!-- 
    Example

    [My Website][1] 
-->

> **TODO** Create a reference link to your website and reference it three times

You can also link to other locations on your markdown page.  Remember, your MarkDown will get converted to HTML, so you can, in theory, use a anchor tag to link to an element with a specific ID.  You can find an example of this in the list of sections at the top of this document.

When we create a header tag for example, it implicitly creates an id property.

Ex '# Header' becomes `<h1 id="header">Header</h1>`

Names will be converted to ids by replacing spaces with hyphens and uppercase letters with lowercase letters (think css naming convention).

Ex 'Header Info' becomes header-info

> **TODO** Create a link to another part of your page.


---

## Images

Defining an image is similar to defining a link, except you prefix it with '!'

<!-- 
    Example

    ![James Quick](https://pbs.twimg.com/profile_images/887455546890211329/tAoS7KUm_400x400.jpg) 
-->

Just like links, you can define images by reference in the same format.

Define the reference

<!-- 
    Example

    [profile]: https://pbs.twimg.com/profile_images/887455546890211329/tAoS7KUm_400x400.jpg 
-->

Use the reference

<!-- 
    Example

    ![James Quick][profile] 
-->

> **TODO** Create a reference link to your profile picture and then reference it.

---

## Code

You can do inline code with `backticks` (``)

> **TODO** Display a line of text with inline code

You can do blocks of code by surroung it with 3 backticks (``` ```)

<!-- 
    Example

    ``` 
    var num = 0;
    var num2 = 0;
```
-->

> **TODO** Display a block of code from your favorite language

The above does not give language specific highlighting.  You can specify the programming language immediately following the opening 3 backticks.  You Should see a difference in highliting!


<!-- 
    Example Javascript

    ```javascript
    var num = 0;
    var num2 = 0;
    ``` 
-->

<!--
    Example HTML

    ```html 
    <div>
        <p>This is an html example</p>
    </div>
    ```
-->

> **TODO** Display a block of code from your favorite language while specifying the language


---

## Tables
Tables are useful for displaying rows and columns of data.  Column headers can be defined in between pipes (|).  Headers are separated from table content with a row of dashes (-) (still separated by pipes), and there must be at least 3 dashes between each header.  The row data follows beneath (still separated by pipes).

<!-- 
    Example

    | Header 1    | Header 2    | Header 3    |
    | ----------- | ----------- | ----------- |
    | Row 1 Col 1 | Row 1 Col 2 | Row 1 Col 3 | 
-->


The column definitions and row definitions do not have to have the exact same width sizes, but it would be much more readable.  Notice the output of the following two tables are the same, but the second (the raw markdown) is much more readable.

<!-- 
    Example

    | Header 1 | Header 2 |
    | ----| ---|
    |Loooooooooooooong item 1 | looooooooooong item 2 | 
-->


<!-- 
    Example

    | Header 1                | Header 2              |
    | ----------------------- | --------------------- |
    |Loooooooooooooong item 1 | looooooooooong item 2 | -->

> **TODO** Create a table with three columns and two rows

You can also align (Center, left, right) the text in a column by using colons (:) in the line breaks between headers and rows.  No colon means the default **left alignment**.  Colons on each side signifies **center alignment**.  And a trailing colon means **right alignment**.

> **TODO** Create a table with three columns, one aligned left, one aligned center, and one aligned right

<!-- 
    Example
    
    | Header | Header 1 | Header 2  |
    | ------ | :------: | --------: |
    | Aligned Left | Aligned Center | Aligned Right | 
-->

---

## Custom HTML

Since MarkDown gets automatically converted to HTML, you can add raw HTML directly to your MarkDown.


```html 
<p>Sample HTML Div</p>
```

Creates this 

<p>Sample HTML Div</p>

> **TODO** If you are comfortable with HTML, add some raw HTML.

---

## Custom CSS

You can also add custom CSS to your MarkDown to add additional styling to your document. You can also include CSS by including a style tag.

```html
    <style>
        body {
            color:red;
        }
    </style>
```
> **TODO** If you are comfortable with CSS, give your page some style.

---

## Additional Resources
- [Markdown Cheat Sheet - Adam P on Github](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#images)
- [Daring Fireball Markdown Syntax](https://daringfireball.net/projects/markdown/syntax)
- [MarkDown in Visual Studio Code](https://code.visualstudio.com/docs/languages/markdown)
