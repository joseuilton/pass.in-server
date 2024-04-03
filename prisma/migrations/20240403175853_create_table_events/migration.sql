-- CreateTable
CREATE TABLE "events" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "details" TEXT,
    "maximum_attendees" INTEGER,
    "slug" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "events_slug_key" ON "events"("slug");
