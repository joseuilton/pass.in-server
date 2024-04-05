-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_check-ins" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attendeeId" INTEGER NOT NULL,
    CONSTRAINT "check-ins_attendeeId_fkey" FOREIGN KEY ("attendeeId") REFERENCES "attendees" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_check-ins" ("attendeeId", "createdAt", "id") SELECT "attendeeId", "createdAt", "id" FROM "check-ins";
DROP TABLE "check-ins";
ALTER TABLE "new_check-ins" RENAME TO "check-ins";
CREATE UNIQUE INDEX "check-ins_attendeeId_key" ON "check-ins"("attendeeId");
CREATE TABLE "new_attendees" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "attendees_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_attendees" ("createdAt", "email", "eventId", "id", "name") SELECT "createdAt", "email", "eventId", "id", "name" FROM "attendees";
DROP TABLE "attendees";
ALTER TABLE "new_attendees" RENAME TO "attendees";
CREATE UNIQUE INDEX "attendees_eventId_email_key" ON "attendees"("eventId", "email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
