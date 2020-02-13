CREATE TABLE book(id INTEGER PRIMARY KEY, title TEXT, photo TEXT,isBuy TEXT, url TEXT, reading TEXT, isLeading TEXT, witchPage TEXT, category TEXT);
CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, email TEXT,phone TEXT,dateLend TEXT,dateBackBook TEXT,idBook TEXT);
