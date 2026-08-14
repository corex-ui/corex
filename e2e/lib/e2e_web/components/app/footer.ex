defmodule E2eWeb.App.Footer do
  use E2eWeb, :html
  alias E2eWeb.App.Shell
  import E2eWeb.LocaleSwitcher
  import E2eWeb.Helpers, only: [hexdocs_url: 0]

  attr(:path, :string, default: "")
  attr(:id, :string, default: nil)

  def footer(assigns) do
    ~H"""
    <footer id={@id} class={Shell.footer() <> " shell-footer"}>
      <div class={Shell.footer_content()}>
        <div class="flex w-full flex-col gap-space-lg md:flex-row md:items-start md:justify-between md:gap-space-xl">
          <div class="flex min-w-0 flex-col gap-space-sm md:max-w-xs">
            <.navigate
              to={~p"/"}
              class="link ui-nav ui-brand ui-size-lg flex flex-nowrap items-center gap-space font-semibold uppercase"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 136 136"
                class="icon ui-size-lg"
              >
                <path
                  d="M70.573 1.67C33.94 1.67 4.243 31.367 4.243 68c0 36.634 29.697 66.33 66.33 66.33s66.33-29.696 66.33-66.33c0-36.633-29.697-66.33-66.33-66.33m.05 102.736c-20.117 0-36.427-16.308-36.427-36.427 0-20.118 16.31-36.427 36.427-36.427 17.055 0 31.37 11.723 35.333 27.55H89.845c-3.365-7.255-10.713-12.301-19.222-12.301-11.678 0-21.179 9.501-21.179 21.18s9.501 21.178 21.18 21.178c8.539 0 15.907-5.08 19.256-12.377h16.095c-3.939 15.864-18.269 27.624-35.352 27.624"
                  fill="currentColor"
                >
                </path>
              </svg>
              Corex
            </.navigate>
            <p class="m-0 text-sm text-ink-muted">
              {~t"Accessible Phoenix UI with a real server-and-client API."}
            </p>
            <p class="m-0 text-sm text-ink-muted">
              {~t"Open source. MIT License."}
            </p>
          </div>

          <div class="grid grid-cols-2 gap-space-sm md:contents">
            <div class="flex flex-col gap-space-sm">
              <p class="m-0 text-sm font-semibold text-ink">{~t"Docs"}</p>
              <.navigate
                class="link ui-nav ui-size-sm"
                to={hexdocs_url() <> "/installation.html"}
                external
              >
                {~t"Installation"}
                <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
              <.navigate
                class="link ui-nav ui-size-sm"
                to={hexdocs_url() <> "/forms.html"}
                external
              >
                {~t"Forms"}
                <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
              <.navigate
                class="link ui-nav ui-size-sm"
                to={hexdocs_url() <> "/theming.html"}
                external
              >
                {~t"Theming"}
                <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
              <.navigate
                class="link ui-nav ui-size-sm"
                to={hexdocs_url() <> "/accessibility.html"}
                external
              >
                {~t"Accessibility"}
                <.heroicon name="hero-arrow-top-right-on-square" />
              </.navigate>
            </div>

            <div class="flex flex-col gap-space-sm">
              <p class="m-0 text-sm font-semibold text-ink">{~t"Explore"}</p>
              <.navigate class="link ui-nav ui-size-sm" to={~p"/accordion/anatomy"}>
                {~t"Components"}
              </.navigate>
              <.navigate class="link ui-nav ui-size-sm" to={~p"/showcases"}>
                {~t"Showcase"}
              </.navigate>
              <.navigate class="link ui-nav ui-size-sm" to={~p"/blog"}>
                {~t"Blog"}
              </.navigate>
            </div>
          </div>

          <div class="flex flex-col gap-space-sm">
            <p class="m-0 text-sm font-semibold text-ink">{~t"Sponsors"}</p>
            <.navigate
              to="https://netoum.com"
              class="inline-flex items-center"
              external
              aria_label={~t"Netoum"}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="666.67 1192.15 1333.33 282.37"
                preserveAspectRatio="xMidYMid meet"
                class="shell-footer__sponsor-mark"
                role="img"
                aria-hidden="true"
              >
                <title>Netoum</title>
                <defs>
                  <linearGradient
                    id="footer-netoum-grad-a"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="0"
                    gradientUnits="userSpaceOnUse"
                    gradientTransform="matrix(-122.33,-2086.6,-2086.6,122.33,5850.04,11026.9)"
                    spreadMethod="pad"
                  >
                    <stop offset="0" stop-color="var(--color-brand)" stop-opacity="1"></stop>
                    <stop offset="1" stop-color="var(--color-info)" stop-opacity="1"></stop>
                  </linearGradient>
                  <clipPath id="footer-netoum-clip-a" clipPathUnits="userSpaceOnUse">
                    <path d="m 5765.77,10410.7 c -155.26,0 -281.54,126.2 -281.54,281.5 0,155.1 126.28,281.3 281.54,281.3 155.07,0 281.35,-126.2 281.35,-281.3 0,-155.3 -126.28,-281.5 -281.35,-281.5 z m 269.88,33.4 c 60.08,65.3 96.84,152.5 96.84,248.1 0,28 -3.16,55.3 -9.16,81.6 -25.29,92.9 -71.6,154.7 -117.98,195.6 -2.7,2.5 -5.59,5 -8.56,7.3 -6.26,5.2 -12.71,10 -19.17,14.8 -6.65,4.6 -13.57,9.2 -20.49,13.4 0.27,0 0.27,0.2 0.47,0.2 -49.47,30.9 -89.59,39.3 -89.59,39.3 -32.35,9.3 -66.73,14.5 -102.24,14.5 -202.23,0 -366.91,-164.4 -366.91,-366.7 0,-106.8 45.92,-203.1 119.16,-270.3 l -474.61,-274 1028.74,-607 21.94,35.1 c 7.7,12.2 14.49,25.3 20.29,39.2 l -74.38,43.6 -827.29,488.2 382.12,220.6 c 51.12,-26.8 109.15,-42.3 170.94,-42.3 74.11,0 142.95,22.1 200.78,60.1 l 454.99,-262.5 v -722.2 l -625.53,-361.1 -543.92,314.1 c 2.51,9.8 3.76,20 3.76,30.5 0,70.8 -57.18,128.1 -127.93,128.1 -70.74,0 -127.92,-57.3 -127.92,-128.1 0,-70.5 57.18,-128 127.92,-128 29.06,0 55.74,9.8 77.01,26.1 l 591.08,-341.2 710.9,410.3 v 820.7 z">
                    </path>
                  </clipPath>
                  <linearGradient
                    id="footer-netoum-grad-b"
                    x1="0"
                    y1="0"
                    x2="1"
                    y2="0"
                    gradientUnits="userSpaceOnUse"
                    gradientTransform="matrix(-122.33,-2086.6,-2086.6,122.33,6128.96,11010.6)"
                    spreadMethod="pad"
                  >
                    <stop offset="0" stop-color="var(--color-brand)" stop-opacity="1"></stop>
                    <stop offset="1" stop-color="var(--color-info)" stop-opacity="1"></stop>
                  </linearGradient>
                  <clipPath id="footer-netoum-clip-b" clipPathUnits="userSpaceOnUse">
                    <path d="m 6176,9620.1 c 3.03,-71.2 -52.21,-131.4 -123.38,-134.4 -71.18,-3 -131.35,52.2 -134.38,123.4 -3.04,71.2 52.2,131.3 123.38,134.4 71.17,3 131.34,-52.2 134.38,-123.4 z">
                    </path>
                  </clipPath>
                </defs>
                <g transform="matrix(0.13333333,0,0,-0.13333333,0,2666.6667)">
                  <path
                    d="m 7998.16,10488.7 v -724.3 l -577.42,724.3 H 7295.7 V 9470.6 h 164.36 v 718.6 l 577.43,-718.6 h 123.65 v 1018.1 h -162.98"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="M 8870.86,9630.6 V 9904 h 561.4 v 151.3 h -561.4 v 274.9 h 584.7 v 158.5 H 8707.99 V 9470.6 h 751.95 v 160 h -589.08"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="m 9856.96,10488.7 v -146.8 h 334.54 v -871.3 h 164.3 v 871.3 h 333.1 v 146.8 h -831.94"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="m 11561.7,9620.4 c -251.7,0 -356.5,193.4 -359.3,373.8 0,222.6 126.5,386.9 362.1,386.9 248.7,-4.4 356.5,-199.2 356.5,-386.9 0,-194.9 -106.3,-373.8 -359.3,-373.8 z m 2.8,909 c -306.9,0 -523.6,-224 -523.6,-533.8 0,-267.6 167.2,-525 520.8,-525 353.4,0 520.6,251.7 520.6,526.5 0,274.9 -170.1,531 -517.8,532.3"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="m 13256.1,10506.6 v -595 c 0,-193.4 -119.3,-299.5 -282.1,-290.9 -151.4,5.9 -259,106.3 -259,290.9 v 595 h -161.5 v -595 c 0,-289.4 193.5,-434.8 420.5,-440.7 245.8,-8.7 443.6,141.2 443.6,440.7 v 595 h -161.5"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="m 14810.9,10488.7 -334.5,-477 -336.1,477 h -189 V 9470.6 h 162.9 v 781.1 l 341.8,-481.5 h 35 l 346.1,481.5 v -781.1 h 162.9 v 1018.1 h -189.1"
                    fill="var(--color-brand)"
                  >
                  </path>
                  <path
                    d="m 5765.77,10410.7 c -155.26,0 -281.54,126.2 -281.54,281.5 0,155.1 126.28,281.3 281.54,281.3 155.07,0 281.35,-126.2 281.35,-281.3 0,-155.3 -126.28,-281.5 -281.35,-281.5 z m 269.88,33.4 c 60.08,65.3 96.84,152.5 96.84,248.1 0,28 -3.16,55.3 -9.16,81.6 -25.29,92.9 -71.6,154.7 -117.98,195.6 -2.7,2.5 -5.59,5 -8.56,7.3 -6.26,5.2 -12.71,10 -19.17,14.8 -6.65,4.6 -13.57,9.2 -20.49,13.4 0.27,0 0.27,0.2 0.47,0.2 -49.47,30.9 -89.59,39.3 -89.59,39.3 -32.35,9.3 -66.73,14.5 -102.24,14.5 -202.23,0 -366.91,-164.4 -366.91,-366.7 0,-106.8 45.92,-203.1 119.16,-270.3 l -474.61,-274 1028.74,-607 21.94,35.1 c 7.7,12.2 14.49,25.3 20.29,39.2 l -74.38,43.6 -827.29,488.2 382.12,220.6 c 51.12,-26.8 109.15,-42.3 170.94,-42.3 74.11,0 142.95,22.1 200.78,60.1 l 454.99,-262.5 v -722.2 l -625.53,-361.1 -543.92,314.1 c 2.51,9.8 3.76,20 3.76,30.5 0,70.8 -57.18,128.1 -127.93,128.1 -70.74,0 -127.92,-57.3 -127.92,-128.1 0,-70.5 57.18,-128 127.92,-128 29.06,0 55.74,9.8 77.01,26.1 l 591.08,-341.2 710.9,410.3 v 820.7 l -471.26,272"
                    fill="url(#footer-netoum-grad-a)"
                    clip-path="url(#footer-netoum-clip-a)"
                  >
                  </path>
                  <path
                    d="m 6176,9620.1 c 3.03,-71.2 -52.21,-131.4 -123.38,-134.4 -71.18,-3 -131.35,52.2 -134.38,123.4 -3.04,71.2 52.2,131.3 123.38,134.4 71.17,3 131.34,-52.2 134.38,-123.4"
                    fill="url(#footer-netoum-grad-b)"
                    clip-path="url(#footer-netoum-clip-b)"
                  >
                  </path>
                </g>
              </svg>
            </.navigate>
            <.navigate
              class="link ui-nav ui-size-sm"
              to="https://github.com/sponsors/corex-ui"
              external
            >
              {~t"Become a sponsor"}
              <.heroicon name="hero-arrow-top-right-on-square" />
            </.navigate>
          </div>
        </div>

        <div class="flex w-full flex-wrap items-center justify-between gap-space border-t border-border pt-space">
          <div class="flex flex-wrap items-center gap-space-sm">
            <.navigate
              to="https://github.com/corex-ui/corex"
              class="button ui-ghost ui-size-sm"
              external
            >
              <svg
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 102 102"
                stroke-width="1.5"
                stroke="currentColor"
                class="icon"
              >
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z"
                  fill="currentColor"
                />
              </svg>
              {~t"GitHub"}
              <.heroicon name="hero-arrow-top-right-on-square" />
            </.navigate>
            <.navigate
              to={hexdocs_url()}
              class="button ui-ghost ui-size-sm"
              external
            >
              <svg
                aria-hidden="true"
                viewBox="0 0 114 100"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                class="icon"
              >
                <g>
                  <path
                    d="M47.7086 28.06H65.1941C66.3521 28.06 67.3942 28.4064 68.4364 28.8683L84.1849 0.923785C82.9112 0.346419 81.5216 0 80.0162 0H32.8865C31.1495 0 29.5283 0.461893 28.1388 1.2702L44.2347 28.8683C45.2769 28.2909 46.4348 28.06 47.7086 28.06Z"
                    fill="#FFCC1D"
                  />
                  <path
                    d="M71.2156 31.5242L79.9005 46.5357C80.4794 47.575 80.8268 48.8452 80.8268 49.9999L113.019 50.0001C113.019 48.3834 112.44 46.7667 111.629 45.381L88.1221 4.61897C87.1957 3.00234 85.8061 1.73214 84.185 0.923828L68.4316 28.8608C69.5896 29.5536 70.5208 30.3695 71.2156 31.5242Z"
                    fill="#57CC99"
                  />
                  <path
                    d="M80.827 50C80.827 51.1547 80.4796 52.4249 79.9006 53.4642L71.2158 68.4757C70.6368 69.515 69.7104 70.4387 68.784 71.0161L84.8799 98.6142C86.1537 97.8059 87.3117 96.6511 88.1222 95.3809L111.745 54.6189C112.556 53.2332 113.019 51.6166 113.019 50H80.827Z"
                    fill="#1597E5"
                  />
                  <path
                    d="M65.1943 71.9394H47.7088C46.5508 71.9394 45.5045 71.7067 44.5781 71.2448L28.8325 99.0767C30.1063 99.654 31.3813 99.9994 32.7709 99.9994H80.0164C81.7534 99.9994 83.4993 99.532 84.8889 98.6082L68.784 71.0156C67.626 71.593 66.468 71.9394 65.1943 71.9394Z"
                    fill="#AE4CCF"
                  />
                  <path
                    d="M33.0024 46.535L41.6872 31.5235C42.2662 30.4842 43.3099 29.435 44.2363 28.8577L28.1389 1.26953C26.8651 2.07784 25.7071 3.23257 24.8965 4.61825L1.27378 45.3803C0.463192 46.7659 0 48.3826 0 49.9992H32.076C32.076 48.8445 32.4234 47.5743 33.0024 46.535Z"
                    fill="#FF8243"
                  />
                  <path
                    d="M41.6872 68.4757L33.0024 53.4642C32.4234 52.4249 32.076 51.1547 32.076 50H0C0 51.6166 0.463192 53.2332 1.27378 54.6189L24.8965 95.3809C25.8229 96.9976 27.2125 98.2678 28.8337 99.0761L44.5822 71.2471C43.3084 70.5542 42.382 69.6304 41.6872 68.4757Z"
                    fill="#FF4848"
                  />
                </g>
              </svg>
              {~t"Hexdocs"}
              <.heroicon name="hero-arrow-top-right-on-square" />
            </.navigate>
          </div>
          <div class={"#{Shell.row()} gap-space flex-wrap justify-end items-center min-w-0"}>
            <.locale_switcher path={@path} />
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
