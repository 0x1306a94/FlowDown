# Objects - The Database

**Conversation (1) ----- (n) Message (1) ----- (n) Attachment**

CREATE TABLE Attachment (
    id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    data BLOB NOT NULL,
    previewImageData BLOB NOT NULL,
    representedDocument TEXT NOT NULL DEFAULT '',
    messageId INTEGER NOT NULL,
    FOREIGN KEY (messageId) REFERENCES Message (id) ON DELETE CASCADE
);

CREATE TABLE Conversation (
    id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    title TEXT NOT NULL DEFAULT '',
    creation REAL NOT NULL DEFAULT 0,
    icon BLOB,
    model TEXT
);

CREATE TABLE Message (
    id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    document TEXT NOT NULL DEFAULT '',
    documentNodes BLOB NOT NULL,
    conversationId INTEGER NOT NULL,
    FOREIGN KEY (conversationId) REFERENCES Conversation (id) ON DELETE CASCADE
);

CREATE TABLE Model (
    id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    document TEXT NOT NULL DEFAULT '',
    documentNodes BLOB NOT NULL
);

