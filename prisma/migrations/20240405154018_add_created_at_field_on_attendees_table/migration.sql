-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_attendees" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "attendees_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_attendees" ("email", "eventId", "id", "name") SELECT "email", "eventId", "id", "name" FROM "attendees";
DROP TABLE "attendees";
ALTER TABLE "new_attendees" RENAME TO "attendees";
CREATE UNIQUE INDEX "attendees_eventId_email_key" ON "attendees"("eventId", "email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
