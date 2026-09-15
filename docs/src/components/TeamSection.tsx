import React from 'react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const TeamSection: React.FC = () => {
  const teamMembers = [
    {
      name: 'M.F.M. FAZLY',
      cnLink: 'https://thecn.com/EF509',
      githubLink: 'https://github.com/Mhd-Fazly',
      linkedinLink: 'https://www.linkedin.com/in/mohamed-fazly-9b0108319/',
      image: getAssetUrl('assets/team/fazly.png'),
      rawImage: 'assets/team/fazly.png'
    },
    {
      name: 'A.H.M. RAYID',
      cnLink: 'https://thecn.com/ER757',
      githubLink: 'https://github.com/Raygit2024',
      linkedinLink: 'https://www.linkedin.com/in/rayid-hussain-32a2b726a/',
      image: getAssetUrl('assets/team/rayid.png'),
      rawImage: 'assets/team/rayid.png'
    },
    {
      name: 'R.M. RINOS',
      cnLink: 'https://thecn.com/ER760',
      githubLink: 'https://github.com/ramlanrinos',
      linkedinLink: 'https://www.linkedin.com/in/rinos02/',
      image: getAssetUrl('assets/team/rinos.png'),
      rawImage: 'assets/team/rinos.png'
    },
    {
      name: 'A.M.M. SAABITH',
      cnLink: 'https://thecn.com/SM3230',
      githubLink: 'https://github.com/MohamedSaabith342',
      linkedinLink: 'https://www.linkedin.com/in/mohamed-saabith-b5571333a/',
      image: getAssetUrl('assets/team/saabith.png'),
      rawImage: 'assets/team/saabith.png'
    }
  ];

  return (
    <section id="team" className="py-24 relative overflow-hidden bg-slate-100/80 border-t border-slate-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Left-Aligned Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            Meet the Team
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            Engineered by Computer Engineering undergraduates for the Third Year Project.
          </p>
        </div>

        {/* Individual Profile Cards Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {teamMembers.map((member, idx) => (
            <div
              key={idx}
              className="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm hover:shadow-xl hover:border-slate-300 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-2 cursor-pointer"
            >
              <div>
                {/* Member Portrait Image Container */}
                <div className="relative rounded-2xl overflow-hidden mb-5 bg-slate-100 border border-slate-200 aspect-square group-hover:border-slate-300 transition-colors">
                  <img
                    src={member.image}
                    onError={(e) => handleImageError(e, member.rawImage)}
                    alt={member.name}
                    className="w-full h-full object-cover object-center group-hover:scale-105 transition-transform duration-500"
                  />
                </div>

                <h3 className="text-lg font-bold text-slate-900 mb-4 group-hover:text-blue-600 transition-colors duration-200 text-center">
                  {member.name}
                </h3>
              </div>

              <div className="pt-4 border-t border-slate-200/80 flex items-center justify-center gap-2.5">
                {/* CN Profile Link */}
                <a
                  href={member.cnLink}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-9 h-9 rounded-xl bg-white border border-slate-200 shadow-sm p-1.5 flex items-center justify-center shrink-0 hover:border-emerald-500 hover:shadow-md hover:scale-105 transition-all group/cn"
                  aria-label={`View CN profile for ${member.name}`}
                  title={`View ${member.name}'s CN Profile`}
                >
                  <img
                    src={getAssetUrl('assets/cn.jpg')}
                    onError={(e) => handleImageError(e, 'assets/cn.jpg')}
                    alt="Course Networking Logo"
                    className="w-full h-full object-contain rounded group-hover/cn:opacity-90 transition-opacity"
                  />
                </a>

                {/* LinkedIn Profile Link */}
                <a
                  href={member.linkedinLink}
                  target={member.linkedinLink !== '#' ? '_blank' : undefined}
                  rel={member.linkedinLink !== '#' ? 'noopener noreferrer' : undefined}
                  className="w-9 h-9 rounded-xl bg-white border border-slate-200 shadow-sm p-1.5 flex items-center justify-center shrink-0 hover:border-blue-500 hover:shadow-md hover:scale-105 transition-all group/li"
                  aria-label={`View LinkedIn profile for ${member.name}`}
                  title={`View ${member.name}'s LinkedIn Profile`}
                >
                  <img
                    src={getAssetUrl('assets/linkedIn.jpg')}
                    onError={(e) => handleImageError(e, 'assets/linkedIn.jpg')}
                    alt="LinkedIn Logo"
                    className="w-full h-full object-contain rounded group-hover/li:opacity-90 transition-opacity"
                  />
                </a>

                {/* GitHub Profile Link */}
                <a
                  href={member.githubLink}
                  target={member.githubLink !== '#' ? '_blank' : undefined}
                  rel={member.githubLink !== '#' ? 'noopener noreferrer' : undefined}
                  className="w-9 h-9 rounded-xl bg-white border border-slate-200 shadow-sm p-1.5 flex items-center justify-center shrink-0 hover:border-slate-800 hover:shadow-md hover:scale-105 transition-all group/gh"
                  aria-label={`View GitHub profile for ${member.name}`}
                  title={`View ${member.name}'s GitHub Profile`}
                >
                  <img
                    src={getAssetUrl('assets/github.png')}
                    onError={(e) => handleImageError(e, 'assets/github.png')}
                    alt="GitHub Logo"
                    className="w-full h-full object-contain rounded group-hover/gh:opacity-90 transition-opacity"
                  />
                </a>
              </div>
            </div>
          ))}
        </div>

      </div>
    </section>
  );
};


