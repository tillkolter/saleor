export const xsBreakpoint = 576;
export const smBreakpoint = 768;
export const mdBreakpoint = 992;
export const lgBreakpoint = 1200;

export const isMobile = () => {
  	return window.innerWidth < smBreakpoint;
}

export const isTablet = () => {
  	return window.innerWidth >= smBreakpoint && window.innerWidth <= mdBreakpoint;
}

export const getReleaseListColumnNumber = () => {
  if (isMobile()) {
    return 1
  } else if (isTablet()) {
    return 4
  } else {
    return 6
  }
}
