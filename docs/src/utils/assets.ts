export const getAssetUrl = (path: string): string => {
  if (!path) return '';
  if (path.startsWith('http://') || path.startsWith('https://') || path.startsWith('data:')) {
    return path;
  }
  const cleanPath = path.startsWith('/') ? path.slice(1) : path;
  const baseUrl = import.meta.env.BASE_URL || '/';
  const prefix = baseUrl.endsWith('/') ? baseUrl : `${baseUrl}/`;
  return encodeURI(`${prefix}${cleanPath}`);
};

export const handleImageError = (e: React.SyntheticEvent<HTMLImageElement, Event>, relativePath: string) => {
  const target = e.currentTarget;
  const cleanPath = relativePath.startsWith('/') ? relativePath.slice(1) : relativePath;
  const fallbackUrl = encodeURI(`/${cleanPath}`);
  if (target.src !== new URL(fallbackUrl, window.location.origin).href) {
    target.src = fallbackUrl;
  }
};
