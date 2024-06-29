<script>
  import DarkmodeButton from "./DarkmodeButton.svelte";
  import IconLink from "./IconLink.svelte";
  import GithubIcon from "./svg/GithubIcon.svelte";

  import Logo from "./svg/Logo.svelte";
  import YoutubeIcon from "./svg/YoutubeIcon.svelte";
</script>

<header
  class="fixed inset-x-0 top-0 z-10 border-b
    bg-white dark:border-gray-800 dark:bg-dark-background"
>
  <nav
    class="mx-auto flex h-20 max-w-5xl
    items-center justify-between px-4"
  >
    <a href="/"> <Logo class="h-2: w-20" /> </a>
    <p class="text-2xl font-bold">Sunu's Blog</p>

    <div class="flex items-center space-x-1">
      <DarkmodeButton />

      <IconLink
        href="https://www.youtube.com/channel/UCmwqR95FEi94UU1yQHLhTMA"
        target="_blank"
      >
        <YoutubeIcon class="h-8 w-8 fill-current" />
      </IconLink>
      <IconLink href="https://github.com/nopeholmes" target="_blank">
        <GithubIcon class="h-8 w-8 fill-current" />
      </IconLink>
    </div>
  </nav>
</header>
