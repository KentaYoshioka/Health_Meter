const video = document.getElementById("performance-video");
  const totalActivities = 13;
  let videoDuration = 0;

  video.addEventListener("loadedmetadata", () => {
    videoDuration = video.duration;
    console.log("Video metadata loaded. Duration:", videoDuration);

    const playButtons = document.querySelectorAll(".play-activity");
    console.log("Play buttons found:", playButtons.length);

    playButtons.forEach(button => {
      button.addEventListener("click", () => {
        const index = parseInt(button.dataset.index, 10) - 1;
        console.log("Button clicked. Index:", index);

        if (videoDuration > 0) {
          const segmentDuration = videoDuration / totalActivities;
          const startTime = index * segmentDuration;
          console.log("Segment duration:", segmentDuration);
          console.log("Calculated start time:", startTime);

          video.currentTime = startTime;
          video.play();
          console.log("Video playback started at:", startTime);
        } else {
          console.warn("Video duration is 0. Cannot calculate start time.");
        }
      });
    });
  });

  video.addEventListener("error", (e) => {
    console.error("Video error:", e);
  });